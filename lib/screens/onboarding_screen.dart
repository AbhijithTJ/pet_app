import 'package:flutter/material.dart';
import 'package:pet_app/screens/home_screen.dart';
import 'package:pet_app/theme/app_colors.dart';
import 'package:pet_app/l10n/app_localizations.dart';
import 'package:pet_app/main.dart';
import 'package:pet_app/screens/category_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> getOnboardingData(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        "title1": l10n.onboarding1Title1,
        "title2": l10n.onboarding1Title2,
        "text": l10n.onboarding1Text,
        "image": "assets/images/on_bording/dog_and_cat_1.png"
      },
      {
        "title1": l10n.onboarding2Title1,
        "title2": l10n.onboarding2Title2,
        "text": l10n.onboarding2Text,
        "image": "assets/images/on_bording/caw_smile.png"
      },
      {
        "title1": l10n.onboarding3Title1,
        "title2": l10n.onboarding3Title2,
        "text": l10n.onboarding3Text,
        "image": "assets/images/on_bording/dog_and_cat_2.png"
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboardingData = getOnboardingData(context);
    final isMalayalam = Localizations.localeOf(context).languageCode == 'ml';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF2ED), // Soft beige background matching images
      body: Stack(
        children: [
          // Paw Print Overlays (Background)
          Positioned(
            top: 80,
            left: 20,
            child: Transform.rotate(
              angle: -0.2,
              child: Icon(Icons.pets, size: 40, color: AppColors.primaryOrange.withOpacity(0.12)),
            ),
          ),
          Positioned(
            top: 50,
            right: 40,
            child: Transform.rotate(
              angle: 0.3,
              child: Icon(Icons.pets, size: 24, color: AppColors.secondaryTeal.withOpacity(0.15)),
            ),
          ),
          Positioned(
            bottom: 250,
            left: -10,
            child: Transform.rotate(
              angle: 0.1,
              child: Icon(Icons.pets, size: 60, color: AppColors.primaryOrange.withOpacity(0.08)),
            ),
          ),
          Positioned(
            bottom: 180,
            right: 30,
            child: Transform.rotate(
              angle: -0.3,
              child: Icon(Icons.pets, size: 45, color: AppColors.secondaryTeal.withOpacity(0.1)),
            ),
          ),
          Positioned(
            top: 350,
            right: -20,
            child: Transform.rotate(
              angle: 0.4,
              child: Icon(Icons.pets, size: 80, color: AppColors.primaryOrange.withOpacity(0.05)),
            ),
          ),

          // The sliding pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingContent(
                image: onboardingData[index]["image"]!,
                title1: onboardingData[index]["title1"]!,
                title2: onboardingData[index]["title2"]!,
                text: onboardingData[index]["text"]!,
              );
            },
          ),
          
          // Removed Language Toggle (Top Left)

          // Floating Skip button (Top Right)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 10.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const CategorySelectionScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.skip,
                      style: const TextStyle(
                        color: AppColors.secondaryTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Fixed Bottom Controls (Dots & Button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dot indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => buildDot(index: index, onboardingData: onboardingData),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == onboardingData.length - 1) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const CategorySelectionScreen(),
                              ),
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentPage == onboardingData.length - 1
                              ? AppColors.secondaryTeal
                              : AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == onboardingData.length - 1 ? l10n.getStarted : l10n.next,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({required int index, required List<Map<String, String>> onboardingData}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primaryOrange : AppColors.primaryOrange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.image,
    required this.title1,
    required this.title2,
    required this.text,
  });
  final String image, title1, title2, text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fill the background with the UI color so it's consistent
        Container(
          color: AppColors.backgroundCream,
        ),
        
        Column(
          children: [
            // Top Half - Image with a small merging gradient
            Expanded(
              flex: 12,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover, 
                      ),
                    ),
                  ),
                  // Small merging container at the bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 50, 
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.backgroundCream.withOpacity(0.0),
                            AppColors.backgroundCream,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Half - Text
            Expanded(
              flex: 11,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 140.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              height: 1.2,
                            ),
                        children: [
                          TextSpan(text: title1),
                          TextSpan(
                            text: title2,
                            style: const TextStyle(color: AppColors.primaryOrange),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
