import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/ai_assistant.dart';
import '../services/ai_assistant_service.dart';
import '../widgets/faq_item_widget.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AIAssistantService _aiService = AIAssistantService.instance;
  
  List<FAQItem> _allFAQs = [];
  List<String> _categories = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFAQData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFAQData() async {
    try {
      await _aiService.initialize();
      final categories = _aiService.getFAQCategories();
      
      setState(() {
        _categories = ['الكل', ...categories];
        _tabController = TabController(length: _categories.length, vsync: this);
        _allFAQs = _aiService.getPopularFAQs();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading FAQ data: $e');
    }
  }

  List<FAQItem> get _filteredFAQs {
    List<FAQItem> faqs;
    
    if (_tabController.index == 0) {
      // "الكل" tab
      faqs = _allFAQs;
    } else {
      // Specific category
      final category = _categories[_tabController.index];
      faqs = _aiService.getFAQsByCategory(category);
    }
    
    if (_searchQuery.isEmpty) {
      return faqs;
    }
    
    return _aiService.searchFAQs(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          title: const Text('الأسئلة الشائعة'),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('الأسئلة الشائعة'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        bottom: _categories.isNotEmpty ? TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
          onTap: (_) => setState(() {}),
        ) : null,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث في الأسئلة الشائعة...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(color: AppColors.primaryBlue),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // FAQ content
          Expanded(
            child: _categories.isEmpty 
                ? _buildEmptyState()
                : TabBarView(
                    controller: _tabController,
                    children: _categories.map((category) => _buildFAQList()).toList(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAIChat,
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.chat),
        label: const Text('اسأل المساعد الذكي'),
      ),
    );
  }

  Widget _buildFAQList() {
    final faqs = _filteredFAQs;
    
    if (faqs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return FAQItemWidget(
          faq: faq,
          onTap: () => _showFAQDetail(faq),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            _searchQuery.isNotEmpty 
                ? 'لا توجد نتائج للبحث'
                : 'لا توجد أسئلة شائعة',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            _searchQuery.isNotEmpty 
                ? 'جرب البحث بكلمات أخرى'
                : 'يمكنك سؤال المساعد الذكي مباشرة',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: _openAIChat,
            icon: const Icon(Icons.smart_toy),
            label: const Text('اسأل المساعد الذكي'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  void _showFAQDetail(FAQItem faq) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        faq.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.defaultPadding),

                    // Answer
                    Text(
                      faq.answer,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: AppConstants.largePadding),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _openAIChat();
                            },
                            icon: const Icon(Icons.chat),
                            label: const Text('سؤال متابعة'),
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.check),
                            label: const Text('مفهوم'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAIChat() {
    Navigator.of(context).pushNamed('/ai_chat');
  }
}
