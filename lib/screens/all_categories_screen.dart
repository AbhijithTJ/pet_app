import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/screens/category_details_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';
    
    // Fallback for categories that might not have localized strings yet
    String translate(String ml, String en) => isMalayalam ? ml : en;

    final List<Map<String, dynamic>> allCategories = [
      {
        'id': 'cat',
        'name': l10n.cat,
        'image': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=300&auto=format&fit=crop',
        'color': AppColors.categoryCat,
      },
      {
        'id': 'dog',
        'name': l10n.dog,
        'image': 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=300&auto=format&fit=crop',
        'color': AppColors.categoryDog,
      },
      {
        'id': 'bird',
        'name': l10n.bird,
        'image': 'https://images.unsplash.com/photo-1605092676920-8ac5ae40c7c8?q=80&w=300&auto=format&fit=crop',
        'color': AppColors.categoryBird,
      },
      {
        'id': 'fish',
        'name': l10n.fish,
        'image': 'https://images.unsplash.com/photo-1524704796725-9fc3044a58b2?q=80&w=300&auto=format&fit=crop',
        'color': AppColors.categoryFish,
      },
      {
        'id': 'rabbit',
        'name': l10n.rabbit,
        'image': 'https://images.unsplash.com/photo-1585110396000-c9fd45c2cb17?q=80&w=300&auto=format&fit=crop',
        'color': const Color(0xFFFFCCBC),
      },
      {
        'id': 'cow',
        'name': l10n.cow,
        'image': 'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?q=80&w=300&auto=format&fit=crop',
        'color': const Color(0xFFD7CCC8),
      },
      {
        'id': 'turtle',
        'name': l10n.turtle,
        'image': 'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?q=80&w=300&auto=format&fit=crop',
        'color': const Color(0xFFC8E6C9),
      },
      {
        'id': 'snake',
        'name': l10n.snake,
        'image': 'https://images.unsplash.com/photo-1533568024501-de29ce707a0c?q=80&w=300&auto=format&fit=crop',
        'color': const Color(0xFFFFF9C4),
      },
      {
        'id': 'horse',
        'name': l10n.horse,
        'image': 'https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?q=80&w=300&auto=format&fit=crop',
        'color': const Color(0xFFCFD8DC),
      },
      {
        'id': 'hamster',
        'name': translate('ഹാംസ്റ്റർ', 'Hamster'),
        'image': 'https://images.unsplash.com/photo-1425082661705-1834bfd08d98?q=80&w=300&auto=format&fit=crop',
        'color': const Color(0xFFFFE082),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isMalayalam ? 'എല്ലാ വിഭാഗങ്ങളും' : 'All Categories'),
        backgroundColor: AppColors.backgroundCream,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundCream,
      body: GridView.builder(
        padding: const EdgeInsets.all(20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.85,
        ),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailsScreen(
                    category: category['id'],
                    categoryName: category['name'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: category['color'],
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
                      category['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: category['color'],
                        child: const Icon(Icons.pets, size: 50, color: Colors.white54),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          category['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
