import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/main.dart';
import 'package:pet_app/screens/category_details_screen.dart';
import 'package:pet_app/screens/all_categories_screen.dart';
import 'package:pet_app/screens/all_tips_screen.dart';
import 'package:pet_app/screens/article_detail_screen.dart';
import 'package:pet_app/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/api/backend/firebase_service.dart';
import 'package:pet_app/api/backend/preference_service.dart';
import 'package:pet_app/utils/localization_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _selectedCategories = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await PreferenceService().getSelectedCategories();
    setState(() {
      _selectedCategories = prefs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';
    final firebaseService = FirebaseService();
    
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: _buildBody(context, l10n, firebaseService),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surfaceWhite,
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            activeIcon: const Icon(Icons.category),
            label: l10n.categories,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.lightbulb_outline),
            activeIcon: const Icon(Icons.lightbulb),
            label: l10n.tipsAndSuggestions,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, FirebaseService firebaseService) {
    if (_currentIndex == 1) {
      return const AllCategoriesScreen();
    }
    if (_currentIndex == 2) {
      return const AllTipsScreen();
    }
    
    // Default to Home View (index 0)
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                    },
                    child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryOrange.withOpacity(0.2),
                    child: Text(
                      firebaseService.currentUser != null
                          ? (firebaseService.currentUser!.email?.split('@').first.substring(0,2).toUpperCase() ?? "")
                          : "G",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.hello,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                      Text(
                        l10n.welcomeBack,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Language Dropdown
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.language, color: AppColors.primaryOrange),
                    onSelected: (String value) {
                      if (value == 'en') {
                        PetCareApp.setLocale(context, const Locale('en'));
                      } else if (value == 'ml') {
                        PetCareApp.setLocale(context, const Locale('ml'));
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'en',
                        child: Text('English'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'ml',
                        child: Text('മലയാളം'),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Promotional Ads Slider
              StreamBuilder<QuerySnapshot>(
                stream: firebaseService.getSlidersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 190,
                      child: Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SizedBox(); // Fallback if no sliders
                  }

                  return SizedBox(
                    height: 180,
                    child: _AutoSliderWidget(docs: snapshot.data!.docs),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Categories
              Text(
                l10n.categories,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: firebaseService.getCategoriesStream(), // fetch all
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SizedBox(); // Fallback if no data
                  }
                  
                  // Sort docs: selected categories first
                  final docs = snapshot.data!.docs.toList();
                  docs.sort((a, b) {
                    final aSelected = _selectedCategories.contains(a.id);
                    final bSelected = _selectedCategories.contains(b.id);
                    if (aSelected && !bSelected) return -1;
                    if (!aSelected && bSelected) return 1;
                    return 0;
                  });
                  
                  // Limit to 5 for UI
                  final displayDocs = docs.take(5).toList();
                  
                  // Build a grid of up to 6 items (5 from firestore + View All)
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.8, // Adjust for 3 columns
                    ),
                    itemCount: displayDocs.length < 5 ? displayDocs.length + 1 : 6,
                    itemBuilder: (context, index) {
                      if (index == displayDocs.length || index == 5) {
                        return _buildViewAllCard(l10n.viewAll, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AllCategoriesScreen()));
                        });
                      }
                      
                      final doc = displayDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final String id = doc.id;
                      final String name = getLocalizedText(data, 'name', context).isNotEmpty ? getLocalizedText(data, 'name', context) : 'Unknown';
                      final String imageUrl = data['imageUrl'] ?? 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=300&auto=format&fit=crop';
                      final Color color = AppColors.categoryCat; // Default
                      
                      return _buildCategoryCard(name, imageUrl, color, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(category: id, categoryName: name)));
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 32),

              // Tips & Suggestions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.tipsAndSuggestions,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllTipsScreen()));
                    },
                    child: Text(l10n.viewAll, style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: firebaseService.getTipsStream(), // fetch all
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SizedBox();
                  }

                  // Sort docs: tips in selected categories first
                  final docs = snapshot.data!.docs.toList();
                  docs.sort((a, b) {
                    final dataA = a.data() as Map<String, dynamic>;
                    final dataB = b.data() as Map<String, dynamic>;
                    
                    // Assuming tip has a 'category' field pointing to category id
                    final aSelected = _selectedCategories.contains(dataA['category']);
                    final bSelected = _selectedCategories.contains(dataB['category']);
                    
                    if (aSelected && !bSelected) return -1;
                    if (!aSelected && bSelected) return 1;
                    return 0;
                  });

                  // Limit to 2 for UI
                  final displayDocs = docs.take(2).toList();

                  return Column(
                    children: displayDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final String id = doc.id;
                      final String title = getLocalizedText(data, 'title', context).isNotEmpty ? getLocalizedText(data, 'title', context) : 'No Title';
                      final String category = getLocalizedText(data, 'category', context);
                      final String description = getLocalizedText(data, 'description', context).isNotEmpty ? getLocalizedText(data, 'description', context) : 'No Description';
                      final String subtitle = getLocalizedText(data, 'subtitle', context).isNotEmpty ? getLocalizedText(data, 'subtitle', context) : (category.isNotEmpty ? 'Category: $category' : '');
                      final String imageUrl = data['imageUrl'] ?? 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?q=80&w=600&auto=format&fit=crop';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildTipCard(
                          title,
                          subtitle,
                          imageUrl,
                          l10n.readMore,
                          () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(
                              articleId: id,
                              title: title,
                              content: '$subtitle\n\n$description',
                              imageUrl: imageUrl,
                            )));
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
  }

  Widget _buildBannerSlider(String title, String imageUrl) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                   const Icon(Icons.broken_image, color: Colors.grey, size: 50),
              )
            else
              const Icon(Icons.image, color: Colors.grey, size: 50),
            
            // Title text at the bottom
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(4, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: bgColor,
                  child: const Icon(Icons.pets, size: 40, color: Colors.white54),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, left: 8.0, right: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewAllCard(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryOrange.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(4, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 6,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.grid_view_rounded, color: Colors.white, size: 36),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 14, 
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String subtitle, String imageUrl, String readMoreText, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      readMoreText,
                      style: const TextStyle(
                        color: AppColors.surfaceWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class _AutoSliderWidget extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;

  const _AutoSliderWidget({required this.docs});

  @override
  State<_AutoSliderWidget> createState() => _AutoSliderWidgetState();
}

class _AutoSliderWidgetState extends State<_AutoSliderWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, initialPage: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.docs.isEmpty) return;
      if (_currentPage < widget.docs.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.docs.length,
            onPageChanged: (int page) {
              if (mounted) {
                setState(() {
                  _currentPage = page;
                });
              }
            },
            itemBuilder: (context, index) {
              final data = widget.docs[index].data() as Map<String, dynamic>;
              final String title = data['title'] ?? '';
              final String imageUrl = data['imageUrl'] ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildBannerSliderItem(title, imageUrl),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.docs.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index 
                    ? AppColors.primaryOrange 
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerSliderItem(String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                   const Icon(Icons.broken_image, color: Colors.grey, size: 50),
              )
            else
              const Icon(Icons.image, color: Colors.grey, size: 50),
            
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(150, 0, 0, 0),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
