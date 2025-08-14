import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'WanderPlan'**
  String get appTitle;

  /// No description provided for @noTripsAdded.
  ///
  /// In en, this message translates to:
  /// **'No trips added'**
  String get noTripsAdded;

  /// No description provided for @settingsHeader.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsHeader;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @themeHeader.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeHeader;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @createNewTripHeader.
  ///
  /// In en, this message translates to:
  /// **'Create a new trip'**
  String get createNewTripHeader;

  /// No description provided for @tripTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Title'**
  String get tripTitle;

  /// No description provided for @enterTitleHere.
  ///
  /// In en, this message translates to:
  /// **'Enter title here...'**
  String get enterTitleHere;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @noDateSelected.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get noDateSelected;

  /// No description provided for @transportationMethodHeader.
  ///
  /// In en, this message translates to:
  /// **'Transportation Method'**
  String get transportationMethodHeader;

  /// No description provided for @requestedExperiencesHeader.
  ///
  /// In en, this message translates to:
  /// **'Requested Experiences'**
  String get requestedExperiencesHeader;

  /// No description provided for @participantList.
  ///
  /// In en, this message translates to:
  /// **'Participant List'**
  String get participantList;

  /// No description provided for @noParticipantsAdded.
  ///
  /// In en, this message translates to:
  /// **'No participants added yet'**
  String get noParticipantsAdded;

  /// No description provided for @addParticipantButton.
  ///
  /// In en, this message translates to:
  /// **'Add participant'**
  String get addParticipantButton;

  /// No description provided for @cultureExperience.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get cultureExperience;

  /// No description provided for @cuisineExperience.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get cuisineExperience;

  /// No description provided for @hikingExperience.
  ///
  /// In en, this message translates to:
  /// **'Hiking'**
  String get hikingExperience;

  /// No description provided for @swimmingExperience.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get swimmingExperience;

  /// No description provided for @wildlifeExperience.
  ///
  /// In en, this message translates to:
  /// **'Wildlife'**
  String get wildlifeExperience;

  /// No description provided for @artExperience.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get artExperience;

  /// No description provided for @festivalsExperience.
  ///
  /// In en, this message translates to:
  /// **'Festivals'**
  String get festivalsExperience;

  /// No description provided for @shoppingExperience.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shoppingExperience;

  /// No description provided for @adventureExperience.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventureExperience;

  /// No description provided for @discardFiles.
  ///
  /// In en, this message translates to:
  /// **'Discard filled fields until now?'**
  String get discardFiles;

  /// No description provided for @informationWillBeErased.
  ///
  /// In en, this message translates to:
  /// **'The information on the fields will be erased'**
  String get informationWillBeErased;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get discardChanges;

  /// No description provided for @thisFieldCantBeNull.
  ///
  /// In en, this message translates to:
  /// **'This field can\'t be null'**
  String get thisFieldCantBeNull;

  /// No description provided for @nameField.
  ///
  /// In en, this message translates to:
  /// **'Name: '**
  String get nameField;

  /// No description provided for @ageField.
  ///
  /// In en, this message translates to:
  /// **'Age: '**
  String get ageField;

  /// No description provided for @transportField.
  ///
  /// In en, this message translates to:
  /// **'Transport: '**
  String get transportField;

  /// No description provided for @stopoverList.
  ///
  /// In en, this message translates to:
  /// **'Stopover List'**
  String get stopoverList;

  /// No description provided for @noStopoverAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No stopovers added yet'**
  String get noStopoverAddedYet;

  /// No description provided for @stopoverDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Stopover deleted successfully'**
  String get stopoverDeletedSuccessfully;

  /// No description provided for @addStopover.
  ///
  /// In en, this message translates to:
  /// **'addStopover'**
  String get addStopover;

  /// No description provided for @createTrip.
  ///
  /// In en, this message translates to:
  /// **'Create trip'**
  String get createTrip;

  /// No description provided for @choosePictureFrom.
  ///
  /// In en, this message translates to:
  /// **'Choose picture from...'**
  String get choosePictureFrom;

  /// No description provided for @chooseFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Choose from camera'**
  String get chooseFromCamera;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterNameHere.
  ///
  /// In en, this message translates to:
  /// **'Enter name here...'**
  String get enterNameHere;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @enterAgeHere.
  ///
  /// In en, this message translates to:
  /// **'Enter age here...'**
  String get enterAgeHere;

  /// No description provided for @favoriteTransport.
  ///
  /// In en, this message translates to:
  /// **'Favorite Transport'**
  String get favoriteTransport;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cityName.
  ///
  /// In en, this message translates to:
  /// **'City Name'**
  String get cityName;

  /// No description provided for @wasAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **' was added successfully'**
  String get wasAddedSuccessfully;

  /// No description provided for @stopoverSuccessfullyAdded.
  ///
  /// In en, this message translates to:
  /// **'Stopover successfully added!'**
  String get stopoverSuccessfullyAdded;

  /// No description provided for @thereWasAnErrorNominatimAPI.
  ///
  /// In en, this message translates to:
  /// **'There was an error on the attempt of searching places'**
  String get thereWasAnErrorNominatimAPI;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
