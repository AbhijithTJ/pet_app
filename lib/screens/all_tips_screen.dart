import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/screens/article_detail_screen.dart';

class AllTipsScreen extends StatelessWidget {
  const AllTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';

    final List<Map<String, String>> allTips = [
      {
        'title': l10n.tip1Title,
        'subtitle': l10n.tip1Subtitle,
        'content': '${l10n.tip1Subtitle}\n\nHere are some detailed ways to play with your feline friend safely. Ensure you use toys that are not easily swallowable and avoid pointing laser pointers directly into their eyes. Always supervise playtime.',
        'imageUrl': 'https://images.unsplash.com/photo-1495360010541-f48722b34f7d?q=80&w=600&auto=format&fit=crop',
      },
      {
        'title': l10n.tip2Title,
        'subtitle': l10n.tip2Subtitle,
        'content': '${l10n.tip2Subtitle}\n\nDogs require a balanced diet of protein, carbohydrates, and healthy fats. Always consult your vet before making major changes to your dog\'s diet. Fresh water should always be available.',
        'imageUrl': 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?q=80&w=600&auto=format&fit=crop',
      },
      {
        'title': isMalayalam ? 'പക്ഷികളുടെ കൂടുകൾ വൃത്തിയാക്കൽ' : 'Cleaning bird cages',
        'subtitle': isMalayalam ? 'പക്ഷികളുടെ ആരോഗ്യം സംരക്ഷിക്കാൻ കൂടുകൾ എങ്ങെനെ വൃത്തിയാക്കാം' : 'How to clean bird cages to protect their health',
        'content': isMalayalam 
            ? 'പക്ഷികളുടെ ആരോഗ്യം സംരക്ഷിക്കാൻ കൂടുകൾ എങ്ങെനെ വൃത്തിയാക്കാം\n\nആഴ്ചയിൽ ഒരിക്കലെങ്കിലും പക്ഷികളുടെ കൂടുകൾ നന്നായി കഴുകി ഉണക്കണം. പഴകിയ ഭക്ഷണങ്ങളും കാഷ്ഠവും സമയത്തിന് മാറ്റുക.'
            : 'How to clean bird cages to protect their health\n\nWash and dry bird cages thoroughly at least once a week. Remove stale food and droppings on time.',
        'imageUrl': 'https://images.unsplash.com/photo-1518558997970-4fdc6bd6ff71?q=80&w=600&auto=format&fit=crop',
      },
      {
        'title': isMalayalam ? 'അക്വേറിയം പരിപാലനം' : 'Aquarium maintenance',
        'subtitle': isMalayalam ? 'മീനുകൾക്ക് ആരോഗ്യകരമായ ചുറ്റുപാട് ഉറപ്പാക്കാം' : 'Ensure a healthy environment for fishes',
        'content': isMalayalam
            ? 'മീനുകൾക്ക് ആരോഗ്യകരമായ ചുറ്റുപാട് ഉറപ്പാക്കാം\n\nഅക്വേറിയത്തിലെ വെള്ളം കൃത്യമായ ഇടവേളകളിൽ മാറ്റണം. ഫിൽറ്ററുകൾ വൃത്തിയാക്കുകയും മീനുകൾക്ക് മിതമായ ഭക്ഷണം നൽകുകയും ചെയ്യുക.'
            : 'Ensure a healthy environment for fishes\n\nChange the aquarium water at regular intervals. Clean the filters and feed the fish moderately.',
        'imageUrl': 'https://images.unsplash.com/photo-1534961880437-ce5ae2033053?q=80&w=600&auto=format&fit=crop',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tipsAndSuggestions),
        backgroundColor: AppColors.backgroundCream,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundCream,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: allTips.length,
        itemBuilder: (context, index) {
          final tip = allTips[index];
          return _buildTipCard(
            context,
            tip['title']!,
            tip['subtitle']!,
            tip['imageUrl']!,
            l10n.readMore,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailScreen(
                    title: tip['title']!,
                    content: tip['content']!,
                    imageUrl: tip['imageUrl']!,
                  ),
                ),
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
