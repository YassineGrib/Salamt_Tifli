import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/consultation.dart';
import '../widgets/rating_stars.dart';
import '../widgets/availability_calendar.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: CustomScrollView(
        slivers: [
          // App bar with doctor image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60), // Account for status bar
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.doctor.profileImage != null
                          ? NetworkImage(widget.doctor.profileImage!)
                          : null,
                      child: widget.doctor.profileImage == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primaryBlueDark,
                            )
                          : null,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      widget.doctor.specialtyArabic,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Doctor info and tabs
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Quick stats
                Container(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        icon: Icons.star,
                        value: widget.doctor.rating.toString(),
                        label: 'التقييم',
                        color: Colors.amber,
                      ),
                      _buildStatCard(
                        icon: Icons.people,
                        value: widget.doctor.reviewCount.toString(),
                        label: 'المراجعات',
                        color: AppColors.primaryGreen,
                      ),
                      _buildStatCard(
                        icon: Icons.access_time,
                        value: widget.doctor.isAvailable ? 'متاح' : 'غير متاح',
                        label: 'الحالة',
                        color: widget.doctor.isAvailable
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ],
                  ),
                ),

                // Tab bar
                Container(
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
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryGreen,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primaryGreen,
                    tabs: const [
                      Tab(text: 'نبذة'),
                      Tab(text: 'المواعيد'),
                      Tab(text: 'التقييمات'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(),
                _buildAvailabilityTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio
          if (widget.doctor.bio != null) ...[
            const Text(
              'نبذة عن الطبيب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              widget.doctor.bio!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],

          // Qualifications
          const Text(
            'المؤهلات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ...widget.doctor.qualifications.map((qualification) => Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.smallPadding),
                    Expanded(
                      child: Text(
                        qualification,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: AppConstants.largePadding),

          // Languages
          const Text(
            'اللغات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            children: widget.doctor.languages
                .map((language) => Chip(
                      label: Text(language),
                      backgroundColor: AppColors.primaryBlueLight,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityTab() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المواعيد المتاحة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Expanded(
            child: AvailabilityCalendar(
              availableSlots: widget.doctor.availableSlots,
              onSlotSelected: (slot) {
                // Handle slot selection
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    // Mock reviews data
    final reviews = [
      {
        'name': 'أم محمد',
        'rating': 5.0,
        'comment': 'طبيب ممتاز ومتفهم، ساعدني كثيراً مع طفلي',
        'date': '2024-01-15',
      },
      {
        'name': 'أحمد علي',
        'rating': 4.5,
        'comment': 'خدمة سريعة ونصائح مفيدة',
        'date': '2024-01-10',
      },
      {
        'name': 'فاطمة حسن',
        'rating': 5.0,
        'comment': 'أنصح بالدكتور، خبرة عالية في طب الأطفال',
        'date': '2024-01-05',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryBlueLight,
                      child: Text(
                        review['name'].toString().substring(0, 1),
                        style: const TextStyle(
                          color: AppColors.primaryBlueDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.defaultPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['name'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          RatingStars(
                            rating: review['rating'] as double,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      review['date'].toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  review['comment'].toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Add to favorites
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text('إضافة للمفضلة'),
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: widget.doctor.isAvailable
                    ? () {
                        Navigator.of(context).pop();
                        // Navigate to booking with this doctor pre-selected
                      }
                    : null,
                icon: const Icon(Icons.calendar_today),
                label: const Text('حجز موعد'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
