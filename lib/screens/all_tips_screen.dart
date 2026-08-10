import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/screens/article_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/api/backend/firebase_service.dart';
import 'package:pet_app/utils/localization_helper.dart';

class AllTipsScreen extends StatelessWidget {
  const AllTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';
    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tipsAndSuggestions),
        backgroundColor: AppColors.backgroundCream,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundCream,
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getTipsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(isMalayalam ? 'ടിപ്പുകൾ കണ്ടെത്തിയില്ല' : 'No Tips found.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              
              final String title = getLocalizedText(data, 'title', context).isNotEmpty ? getLocalizedText(data, 'title', context) : 'No Title';
              final String category = getLocalizedText(data, 'category', context);
              final String description = getLocalizedText(data, 'description', context).isNotEmpty ? getLocalizedText(data, 'description', context) : 'No Description';
              // Use description as subtitle if subtitle is not present
              final String subtitle = getLocalizedText(data, 'subtitle', context).isNotEmpty ? getLocalizedText(data, 'subtitle', context) : (category.isNotEmpty ? 'Category: $category' : '');
              final String imageUrl = data['imageUrl'] ?? 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?q=80&w=600&auto=format&fit=crop';

              return _buildTipCard(
                context,
                title,
                subtitle,
                imageUrl,
                l10n.readMore,
                () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(
                          articleId: docs[index].id,
                          title: title,
                          content: '$subtitle\n\n$description',
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String title, String subtitle, String imageUrl, String readMoreText, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
