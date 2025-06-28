import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/educational_content.dart';
import '../widgets/educational_category_card.dart';
import '../screens/educational_article_screen.dart';
import '../screens/quiz_screen.dart';

class EducationalLibraryScreen extends StatefulWidget {
  const EducationalLibraryScreen({super.key});

  @override
  State<EducationalLibraryScreen> createState() => _EducationalLibraryScreenState();
}

class _EducationalLibraryScreenState extends State<EducationalLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<EducationalCategory> _categories = [];
  List<Quiz> _quizzes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Progress tracking
  Map<String, bool> _completedArticles = {};
  Map<String, int> _quizScores = {};

  // Filter options
  String _selectedAgeGroup = 'الكل';
  String _selectedCategory = 'الكل';
  final List<String> _ageGroups = ['الكل', '0-2 سنة', '3-5 سنوات', '6-12 سنة', '13+ سنة'];
  final List<String> _categoryFilters = ['الكل', 'السلامة', 'الصحة', 'التغذية', 'النمو', 'التعليم'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEducationalContent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEducationalContent() async {
    try {
      final String jsonString = await rootBundle.loadString(AppConstants.educationalContentFile);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final educationalData = EducationalData.fromJson(jsonData);
      
      setState(() {
        _categories = educationalData.categories;
        _quizzes = educationalData.quizzes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading educational content: $e');
    }
  }

  List<EducationalCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _categories;
    }
    
    return _categories.where((category) {
      return category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          category.articles.any((article) =>
              article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              article.summary.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  List<Quiz> get _filteredQuizzes {
    if (_searchQuery.isEmpty) {
      return _quizzes;
    }
    
    return _quizzes.where((quiz) =>
        quiz.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text(
          'المكتبة التعليمية',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              icon: Icon(Icons.library_books),
              text: 'المقالات',
            ),
            Tab(
              icon: Icon(Icons.quiz),
              text: 'الاختبارات',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Enhanced search and filter section
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'البحث في المقالات والاختبارات...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: const BorderSide(color: AppColors.borderLight),
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundGrey,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Age group filter
                      _buildFilterChip(
                        'الفئة العمرية',
                        _selectedAgeGroup,
                        _ageGroups,
                        (value) => setState(() => _selectedAgeGroup = value),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      // Category filter
                      _buildFilterChip(
                        'التصنيف',
                        _selectedCategory,
                        _categoryFilters,
                        (value) => setState(() => _selectedCategory = value),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      // Progress filter
                      FilterChip(
                        label: const Text('المكتملة فقط'),
                        selected: false,
                        onSelected: (selected) {
                          // TODO: Implement completed filter
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildArticlesTab(),
                      _buildQuizzesTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onSelected,
  ) {
    return PopupMenuButton<String>(
      child: Chip(
        label: Text('$label: $selectedValue'),
        avatar: const Icon(Icons.filter_list, size: 16),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => options
          .map((option) => PopupMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
    );
  }

  Widget _buildArticlesTab() {
    if (_filteredCategories.isEmpty) {
      return _buildEmptyState('لا توجد مقالات', 'جرب البحث بكلمات أخرى');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return EducationalCategoryCard(
          category: category,
          onTap: () => _navigateToCategory(category),
        );
      },
    );
  }

  Widget _buildQuizzesTab() {
    if (_filteredQuizzes.isEmpty) {
      return _buildEmptyState('لا توجد اختبارات', 'جرب البحث بكلمات أخرى');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _filteredQuizzes.length,
      itemBuilder: (context, index) {
        final quiz = _filteredQuizzes[index];
        return _buildQuizCard(quiz);
      },
    );
  }

  Widget _buildQuizCard(Quiz quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToQuiz(quiz),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              // Quiz icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.quiz,
                  color: AppColors.primaryGreen,
                  size: 30,
                ),
              ),

              const SizedBox(width: AppConstants.defaultPadding),

              // Quiz info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${quiz.questions.length} سؤال',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quiz.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textLight,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(EducationalCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EducationalArticleScreen(category: category),
      ),
    );
  }

  void _navigateToQuiz(Quiz quiz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizScreen(quiz: quiz),
      ),
    );
  }
}
