import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class TipsSlider extends StatefulWidget {
  const TipsSlider({super.key});

  @override
  State<TipsSlider> createState() => _TipsSliderState();
}

class _TipsSliderState extends State<TipsSlider> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;

  final List<TipItem> _tips = [
    TipItem(
      title: 'نصيحة السلامة',
      content: 'احتفظ بأرقام الطوارئ في مكان واضح ومرئي للجميع',
      icon: Icons.phone_in_talk,
      color: AppColors.emergencyRed,
    ),
    TipItem(
      title: 'الإسعافات الأولية',
      content: 'تعلم الإسعافات الأولية الأساسية لحماية طفلك في المنزل',
      icon: Icons.medical_services,
      color: AppColors.primaryGreen,
    ),
    TipItem(
      title: 'التطعيمات',
      content: 'تابع جدول التطعيمات بانتظام لحماية طفلك من الأمراض',
      icon: Icons.vaccines,
      color: AppColors.primaryBlue,
    ),
    TipItem(
      title: 'الوقاية',
      content: 'الوقاية خير من العلاج - اتبع إرشادات السلامة دائماً',
      icon: Icons.shield,
      color: AppColors.warning,
    ),
    TipItem(
      title: 'التغذية الصحية',
      content: 'اهتم بالتغذية المتوازنة لنمو صحي وسليم لطفلك',
      icon: Icons.restaurant,
      color: AppColors.success,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentIndex < _tips.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: AppConstants.defaultAnimationDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _tips.length,
              itemBuilder: (context, index) {
                return _buildTipCard(_tips[index]);
              },
            ),
            
            // Page indicators
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _tips.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(TipItem tip) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tip.color,
            tip.color.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                tip.icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tip.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipItem {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  TipItem({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });
}
