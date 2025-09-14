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

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @reviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Review Message'**
  String get reviewMessage;

  /// No description provided for @reviewOwner.
  ///
  /// In en, this message translates to:
  /// **'Review Owner'**
  String get reviewOwner;

  /// No description provided for @labelSelectOwner.
  ///
  /// In en, this message translates to:
  /// **'Select the owner of the review'**
  String get labelSelectOwner;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'select date'**
  String get selectDate;

  /// No description provided for @errorNameCantBeNull.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be null'**
  String get errorNameCantBeNull;

  /// No description provided for @errorDateCantBeNull.
  ///
  /// In en, this message translates to:
  /// **'Date of birth can\'t be null'**
  String get errorDateCantBeNull;

  /// No description provided for @errorProfilePhotoCantBeNull.
  ///
  /// In en, this message translates to:
  /// **'Profile photo can\'t be null'**
  String get errorProfilePhotoCantBeNull;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationError;

  /// No description provided for @errorCityName.
  ///
  /// In en, this message translates to:
  /// **'City name can\'t be null'**
  String get errorCityName;

  /// No description provided for @errorExperience.
  ///
  /// In en, this message translates to:
  /// **'Select at least 1 experience'**
  String get errorExperience;

  /// No description provided for @unknownParticipant.
  ///
  /// In en, this message translates to:
  /// **'Unknown Participant'**
  String get unknownParticipant;

  /// No description provided for @noStopovers.
  ///
  /// In en, this message translates to:
  /// **'There are no stopovers to be shown'**
  String get noStopovers;

  /// No description provided for @deletedParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant deleted successfully'**
  String get deletedParticipant;

  /// No description provided for @errorTripTitleCantBeNull.
  ///
  /// In en, this message translates to:
  /// **'Trip title can\'t be null'**
  String get errorTripTitleCantBeNull;

  /// No description provided for @errorParticipant.
  ///
  /// In en, this message translates to:
  /// **'Add at least 1 participant'**
  String get errorParticipant;

  /// No description provided for @errorStopover.
  ///
  /// In en, this message translates to:
  /// **'Add at least 1 stopover'**
  String get errorStopover;

  /// No description provided for @tripCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Trip create successfully'**
  String get tripCreatedSuccessfully;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @noActivitiesPlanned.
  ///
  /// In en, this message translates to:
  /// **'No activities planned'**
  String get noActivitiesPlanned;

  /// No description provided for @mapLocation.
  ///
  /// In en, this message translates to:
  /// **'Map Location'**
  String get mapLocation;

  /// No description provided for @reviewsHeader.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsHeader;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @youAreAboutToDeleteReview.
  ///
  /// In en, this message translates to:
  /// **'You\'re about to delete this review'**
  String get youAreAboutToDeleteReview;

  /// No description provided for @areYouSureReview.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this review?'**
  String get areYouSureReview;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @reviewDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Review deleted successfully'**
  String get reviewDeletedSuccessfully;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @pdfGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF generated successfully'**
  String get pdfGeneratedSuccessfully;

  /// No description provided for @errorWhileGeneratingPDF.
  ///
  /// In en, this message translates to:
  /// **'Error while generating the PDF'**
  String get errorWhileGeneratingPDF;

  /// No description provided for @youAreAboutToDeleteYourTrip.
  ///
  /// In en, this message translates to:
  /// **'You are about to delete your trip'**
  String get youAreAboutToDeleteYourTrip;

  /// No description provided for @areYouSureYouWantToDeleteYourTrip.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this trip?'**
  String get areYouSureYouWantToDeleteYourTrip;

  /// No description provided for @tripDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Trip deleted successfully'**
  String get tripDeletedSuccessfully;
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
