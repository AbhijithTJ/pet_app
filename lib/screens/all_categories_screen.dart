import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/screens/category_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/api/backend/firebase_service.dart';
import 'package:pet_app/utils/localization_helper.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';
    
    // Fallback for categories that might not have localized strings yet
    String translate(String ml, String en) => isMalayalam ? ml : en;

    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text(isMalayalam ? 'എല്ലാ വിഭാഗങ്ങളും' : 'All Categories'),
        backgroundColor: AppColors.backgroundCream,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundCream,
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(isMalayalam ? 'വിഭാഗങ്ങൾ കണ്ടെത്തിയില്ല' : 'No Categories found.'));
          }

          final docs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(20.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.85,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              final String id = doc.id;
              final String name = getLocalizedText(data, 'name', context).isNotEmpty ? getLocalizedText(data, 'name', context) : 'Unknown';
              final String imageUrl = data['imageUrl'] ?? 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=300&auto=format&fit=crop';
              // Use a default color fallback if not in data
              final Color color = AppColors.categoryCat;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailsScreen(
                        category: id,
                        categoryName: name,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
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
                        imageUrl.isNotEmpty 
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: color,
                              child: const Icon(Icons.pets, size: 50, color: Colors.white54),
                            ),
                          )
                        : Container(
                            color: color,
                            child: const Icon(Icons.pets, size: 50, color: Colors.white54),
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
                              name,
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
          );
        },
      ),
    );
  }
}
