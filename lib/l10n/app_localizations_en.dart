// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WanderPlan';

  @override
  String get noTripsAdded => 'No trips added';

  @override
  String get language => 'Language';

  @override
  String get themeHeader => 'Theme';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get tripTitle => 'Trip Title';

  @override
  String get enterTitleHere => 'Enter title here...';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get noDateSelected => 'No date selected';

  @override
  String get transportationMethodHeader => 'Transportation Method';

  @override
  String get requestedExperiencesHeader => 'Requested Experiences';

  @override
  String get participantList => 'Participant List';

  @override
  String get noParticipantsAdded => 'No participants added yet';

  @override
  String get addParticipantButton => 'Add participant';

  @override
  String get settingsHeader => 'Settings';

  @override
  String get createNewTripHeader => 'Create a new trip';
}
