import 'package:flutter/material.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/screens/article_detail_screen.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String category;
  final String categoryName;

  const CategoryDetailsScreen({super.key, required this.category, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';
    final articles = _getArticlesForCategory(category, isMalayalam);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: AppColors.backgroundCream,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundCream,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            shadowColor: Colors.black12,
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(
                      title: article['title']!,
                      content: article['content']!,
                      imageUrl: article['imageUrl']!,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    article['imageUrl']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article['summary']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getArticlesForCategory(String category, bool isMalayalam) {
    if (category == 'cat') {
      return [
        {
          'title': isMalayalam ? 'എങ്ങനെ പൂച്ചകളുടെ ചെള്ള് കളയാം' : 'How to remove cat fleas',
          'summary': isMalayalam ? 'പൂച്ചകളിലെ ചെള്ള് ശല്യം ഒഴിവാക്കാനുള്ള എളുപ്പവഴികൾ.' : 'Easy ways to get rid of flea infestation in cats.',
          'content': isMalayalam 
              ? 'പൂച്ചകളിലെ ചെള്ള് കളയാൻ മികച്ച ഷാംപൂ ഉപയോഗിച്ച് കുളിപ്പിക്കുക. ഒപ്പം വെറ്റിനറി ഡോക്ടറുടെ നിർദ്ദേശപ്രകാരം മരുന്നുകൾ നൽകാം. വീടും പരിസരവും എപ്പോഴും വൃത്തിയായി സൂക്ഷിക്കുക.'
              : 'Bathe the cat using a good anti-flea shampoo. You can also give medicines as prescribed by a veterinary doctor. Always keep the house and surroundings clean.',
          'imageUrl': 'https://images.unsplash.com/photo-1513245543132-31f507417b26?q=80&w=600&auto=format&fit=crop',
        },
        {
          'title': isMalayalam ? 'പൂച്ചകളുടെ ഭക്ഷണം' : 'Cat diet',
          'summary': isMalayalam ? 'പൂച്ചകൾക്ക് നൽകേണ്ട ആരോഗ്യകരമായ ഭക്ഷണങ്ങൾ.' : 'Healthy foods to feed your cats.',
          'content': isMalayalam
              ? 'പൂച്ചകൾക്ക് പ്രോട്ടീൻ അടങ്ങിയ ഭക്ഷണം നിർബന്ധമാണ്. വേവിച്ച മത്സ്യം, മാംസം എന്നിവ നൽകാം. ഉണങ്ങിയ പെറ്റ് ഫുഡും മികച്ചതാണ്.'
              : 'Cats require protein-rich food. You can feed them boiled fish and meat. Dry pet food is also a great option.',
          'imageUrl': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?q=80&w=600&auto=format&fit=crop',
        }
      ];
    } else if (category == 'dog') {
      return [
        {
          'title': isMalayalam ? 'നായ്ക്കളുടെ പരിശീലനം' : 'Dog training',
          'summary': isMalayalam ? 'നിങ്ങളുടെ നായയെ എങ്ങനെ പരിശീലിപ്പിക്കാം.' : 'How to train your dog effectively.',
          'content': isMalayalam
              ? 'ചെറുപ്പത്തിൽ തന്നെ നായ്ക്കൾക്ക് അടിസ്ഥാന പരിശീലനം നൽകണം. നല്ല പെരുമാറ്റത്തിന് പ്രതിഫലം നൽകുന്നത് പരിശീലനം എളുപ്പമാക്കും.'
              : 'Dogs should be given basic training at a young age. Rewarding good behavior makes training much easier.',
          'imageUrl': 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=600&auto=format&fit=crop',
        }
      ];
    } else {
      return [
        {
          'title': isMalayalam ? 'കൂടുതൽ വിവരങ്ങൾ' : 'More information',
          'summary': isMalayalam ? 'ഈ വിഭാഗത്തിൽ ഉടൻ തന്നെ വിവരങ്ങൾ ചേർക്കുന്നതാണ്.' : 'Information in this section will be added soon.',
          'content': isMalayalam
              ? 'ഈ മൃഗങ്ങളെക്കുറിച്ചുള്ള കൂടുതൽ വിവരങ്ങൾ ഉടൻ തന്നെ അപ്ഡേറ്റ് ചെയ്യുന്നതാണ്.'
              : 'More detailed information about these animals will be updated shortly.',
          'imageUrl': 'https://images.unsplash.com/photo-1516134884203-b097b6e92b8d?q=80&w=600&auto=format&fit=crop',
        }
      ];
    }
  }
}
