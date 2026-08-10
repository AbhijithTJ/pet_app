import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ml'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet Care Tips 🐾'**
  String get appTitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboarding1Title1.
  ///
  /// In en, this message translates to:
  /// **'Everything Your\n'**
  String get onboarding1Title1;

  /// No description provided for @onboarding1Title2.
  ///
  /// In en, this message translates to:
  /// **'Pet Needs'**
  String get onboarding1Title2;

  /// No description provided for @onboarding1Text.
  ///
  /// In en, this message translates to:
  /// **'Valatti is your friendly guide for daily pet care, health tips, and a happier pet life.'**
  String get onboarding1Text;

  /// No description provided for @onboarding2Title1.
  ///
  /// In en, this message translates to:
  /// **'Simple Tips,\n'**
  String get onboarding2Title1;

  /// No description provided for @onboarding2Title2.
  ///
  /// In en, this message translates to:
  /// **'Happy Pets'**
  String get onboarding2Title2;

  /// No description provided for @onboarding2Text.
  ///
  /// In en, this message translates to:
  /// **'Easy-to-follow tips and advice for your pet\'s health, hygiene, nutrition, and more.'**
  String get onboarding2Text;

  /// No description provided for @onboarding3Title1.
  ///
  /// In en, this message translates to:
  /// **'Stronger Bond,\n'**
  String get onboarding3Title1;

  /// No description provided for @onboarding3Title2.
  ///
  /// In en, this message translates to:
  /// **'Better Life'**
  String get onboarding3Title2;

  /// No description provided for @onboarding3Text.
  ///
  /// In en, this message translates to:
  /// **'Understand your pet better and build a stronger bond every single day.'**
  String get onboarding3Text;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @promo1Title.
  ///
  /// In en, this message translates to:
  /// **'50% Off Premium\nDog Food'**
  String get promo1Title;

  /// No description provided for @promo1Button.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get promo1Button;

  /// No description provided for @promo2Title.
  ///
  /// In en, this message translates to:
  /// **'New Arrival:\nCat Toys'**
  String get promo2Title;

  /// No description provided for @promo2Button.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get promo2Button;

  /// No description provided for @promo3Title.
  ///
  /// In en, this message translates to:
  /// **'Free Vet\nConsultation'**
  String get promo3Title;

  /// No description provided for @promo3Button.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get promo3Button;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @cat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get cat;

  /// No description provided for @dog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get dog;

  /// No description provided for @bird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get bird;

  /// No description provided for @fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// No description provided for @tipsAndSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Tips & Suggestions'**
  String get tipsAndSuggestions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @tip1Title.
  ///
  /// In en, this message translates to:
  /// **'Catching Tips for your pet cat'**
  String get tip1Title;

  /// No description provided for @tip1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn the best ways to play with your feline friend safely.'**
  String get tip1Subtitle;

  /// No description provided for @tip2Title.
  ///
  /// In en, this message translates to:
  /// **'Healthy diet for dogs'**
  String get tip2Title;

  /// No description provided for @tip2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Essential nutrition facts you need to know today.'**
  String get tip2Subtitle;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get navTips;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @chooseCategories.
  ///
  /// In en, this message translates to:
  /// **'Choose your favorite categories'**
  String get chooseCategories;

  /// No description provided for @selectUpTo5.
  ///
  /// In en, this message translates to:
  /// **'Select up to 5 categories'**
  String get selectUpTo5;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @rabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get rabbit;

  /// No description provided for @cow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get cow;

  /// No description provided for @turtle.
  ///
  /// In en, this message translates to:
  /// **'Turtle'**
  String get turtle;

  /// No description provided for @snake.
  ///
  /// In en, this message translates to:
  /// **'Snake'**
  String get snake;

  /// No description provided for @horse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get horse;

  /// No description provided for @welcomeToValatti.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Valatti'**
  String get welcomeToValatti;

  /// No description provided for @subtitleValatti.
  ///
  /// In en, this message translates to:
  /// **'Your ultimate pet care companion'**
  String get subtitleValatti;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue to your account'**
  String get loginToContinue;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get emailOrPhone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create an account to get started'**
  String get createAccountToGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get iAgreeTo;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to login to post a comment or like this article.'**
  String get loginRequiredMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guest;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
