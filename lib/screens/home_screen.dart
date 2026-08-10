import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/main.dart';
import 'package:pet_app/screens/category_details_screen.dart';
import 'package:pet_app/screens/all_categories_screen.dart';
import 'package:pet_app/screens/all_tips_screen.dart';
import 'package:pet_app/screens/article_detail_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';
    
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150&auto=format&fit=crop'),
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
              SizedBox(
                height: 190,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _buildPromoCard(
                      l10n.promo1Title,
                      l10n.promo1Button,
                      AppColors.bannerGradientStart,
                      AppColors.bannerGradientEnd,
                      Icons.shopping_bag,
                    ),
                    const SizedBox(width: 16),
                    _buildPromoCard(
                      l10n.promo2Title,
                      l10n.promo2Button,
                      const Color(0xFFFFF9C4),
                      const Color(0xFFFFE082),
                      Icons.toys,
                    ),
                    const SizedBox(width: 16),
                    _buildPromoCard(
                      l10n.promo3Title,
                      l10n.promo3Button,
                      AppColors.categoryCat,
                      AppColors.primaryOrange.withValues(alpha: 0.5),
                      Icons.medical_services,
                    ),
                  ],
                ),
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
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryCard(l10n.cat, 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=150&auto=format&fit=crop', AppColors.categoryCat, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(category: 'cat', categoryName: l10n.cat)));
                      }),
                      _buildCategoryCard(l10n.dog, 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=150&auto=format&fit=crop', AppColors.categoryDog, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(category: 'dog', categoryName: l10n.dog)));
                      }),
                      _buildCategoryCard(l10n.bird, 'https://images.unsplash.com/photo-1605092676920-8ac5ae40c7c8?q=80&w=150&auto=format&fit=crop', AppColors.categoryBird, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(category: 'bird', categoryName: l10n.bird)));
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryCard(l10n.fish, 'https://images.unsplash.com/photo-1524704796725-9fc3044a58b2?q=80&w=150&auto=format&fit=crop', AppColors.categoryFish, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(category: 'fish', categoryName: l10n.fish)));
                      }),
                      _buildCategoryCard(l10n.rabbit, 'https://images.unsplash.com/photo-1585110396000-c9fd45c2cb17?q=80&w=150&auto=format&fit=crop', const Color(0xFFFFCCBC), () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailsScreen(category: 'rabbit', categoryName: l10n.rabbit)));
                      }),
                      _buildViewAllCard(l10n.viewAll, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AllCategoriesScreen()));
                      }),
                    ],
                  ),
                ],
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AllTipsScreen()));
                    },
                    child: Text(l10n.viewAll, style: const TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 16),
              _buildTipCard(
                l10n.tip1Title,
                l10n.tip1Subtitle,
                'https://images.unsplash.com/photo-1495360010541-f48722b34f7d?q=80&w=400&auto=format&fit=crop',
                l10n.readMore,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(
                    title: l10n.tip1Title,
                    content: '${l10n.tip1Subtitle}\n\nHere are some detailed ways to play with your feline friend safely. Ensure you use toys that are not easily swallowable and avoid pointing laser pointers directly into their eyes. Always supervise playtime.',
                    imageUrl: 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d?q=80&w=600&auto=format&fit=crop',
                  )));
                },
              ),
              const SizedBox(height: 16),
              _buildTipCard(
                l10n.tip2Title,
                l10n.tip2Subtitle,
                'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?q=80&w=400&auto=format&fit=crop',
                l10n.readMore,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(
                    title: l10n.tip2Title,
                    content: '${l10n.tip2Subtitle}\n\nDogs require a balanced diet of protein, carbohydrates, and healthy fats. Always consult your vet before making major changes to your dog\'s diet. Fresh water should always be available.',
                    imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?q=80&w=600&auto=format&fit=crop',
                  )));
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surfaceWhite,
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            activeIcon: const Icon(Icons.shopping_bag),
            label: l10n.navShop,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.lightbulb_outline),
            activeIcon: const Icon(Icons.lightbulb),
            label: l10n.navTips,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(String title, String buttonText, Color startColor, Color endColor, IconData icon) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ],
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
