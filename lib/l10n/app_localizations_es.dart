// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'WanderPlan';

  @override
  String get noTripsAdded => 'No se han añadido viajes';

  @override
  String get language => 'Idioma';

  @override
  String get themeHeader => 'Tema';

  @override
  String get lightTheme => 'Tema Claro';

  @override
  String get darkTheme => 'Tema Oscuro';

  @override
  String get tripTitle => 'Título del Viaje';

  @override
  String get enterTitleHere => 'Ingrese el título aquí...';

  @override
  String get startDate => 'Inicio';

  @override
  String get endDate => 'Finalización';

  @override
  String get noDateSelected => 'Ninguna fecha';

  @override
  String get transportationMethodHeader => 'Método de Transporte';

  @override
  String get requestedExperiencesHeader => 'Experiencias Solicitadas';

  @override
  String get participantList => 'Lista de Participantes';

  @override
  String get noParticipantsAdded => 'Aún no se han añadido participantes';

  @override
  String get addParticipantButton => 'Añadir participante';

  @override
  String get settingsHeader => 'Configuración';

  @override
  String get createNewTripHeader => 'Crear un nuevo viaje';
}
