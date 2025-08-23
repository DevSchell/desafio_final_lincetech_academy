import 'dart:async';

import 'package:desafio_final_lincetech_academy/entities/coordinate.dart';
import 'package:desafio_final_lincetech_academy/entities/stopover.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/all_widgets.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_action_button.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/coordinates_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/stopover_state.dart';
import 'package:desafio_final_lincetech_academy/use_cases/geolocation/nominatim_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../entities/enum_experiences_list.dart';
import '../../../l10n/app_localizations.dart';

// This bottomSheet is about adding new object "Stopover" to our "stopoverList" in "Trip"
class CustomBottomSheetAddStopover extends StatefulWidget {
  const CustomBottomSheetAddStopover({super.key});

  @override
  State<CustomBottomSheetAddStopover> createState() =>
      _CustomBottomSheetAddStopoverState();
}

class _CustomBottomSheetAddStopoverState
    extends State<CustomBottomSheetAddStopover> {
  //Those are the variables we use to temporarily keep data
  TextEditingController cityNameController = TextEditingController();
  final List<Place> placeSuggestions = [];
  Timer? _debounceTimer;
  late String _searchText = '';
  DateTime? _startDate;
  DateTime? _endDate;
  List<EnumExperiencesList> _selectedStopoverExperiences = [];

  //TEST AREA
  late Place globalFoundPlace;
  double defaultLat = 0;
  double defaultLon = 0;

  CoordinatesProvider coordState = CoordinatesProvider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CustomHeader(
                    text: AppLocalizations.of(context)!.addStopover,
                    size: 20,
                  ),
                ),
                SizedBox(height: 20),

                CustomHeader(text: AppLocalizations.of(context)!.cityName),
                TextFormField(
                  controller: cityNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.enterNameHere,
                  ),

                  /*Here each time the user types, the API searches the value on Nominatim API*/
                  onChanged: (value) async {
                    _searchText = value;
                    if (_debounceTimer?.isActive ?? false) {
                      _debounceTimer!.cancel();
                    }
                    _debounceTimer = Timer(
                      const Duration(milliseconds: 500),
                      () async {
                        final places = await searchPlace(value);
                        placeSuggestions
                            .clear(); //Cleaning the suggestions list
                        /* For each element in places, we will create an object "Place"*/
                        for (var value in places ?? []) {
                          final place = Place.fromJson(value);
                          placeSuggestions.add(place);
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
                /*If placeSuggestions is empty, it'll display nothing,
                * but if there's data there, we'll display a ListView below the TextFormField() with
                * the elements of the List placesSuggestions*/
                Center(
                  child: placeSuggestions.isEmpty
                      ? Text('')
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: placeSuggestions.length,
                            itemBuilder: (context, index) {
                              final foundPlace = placeSuggestions[index];

                              return ListTile(
                                title: Text(
                                  '${foundPlace.cityName}, ${foundPlace.cityState},${foundPlace.cityCountry}',
                                ),
                                onTap: () {
                                  cityNameController.text =
                                      '${foundPlace.cityName}, ${foundPlace.cityState}, ${foundPlace.cityCountry}';
                                  globalFoundPlace = foundPlace;
                                  defaultLon = foundPlace.longitude;
                                  defaultLat = foundPlace.latitude;
                                  placeSuggestions.clear();
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                ),

                CustomDatePicker(
                  onStartDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                ),
                SizedBox(height: 30),

                CustomExperienceList(
                  onChanged: (experiences) {
                    setState(() {
                      _selectedStopoverExperiences = experiences;
                    });
                  },
                ),
                SizedBox(height: 30),

                CustomActionButton(
                  text: AppLocalizations.of(context)!.addStopover,
                  onPressed: () {
                    final selectedStopoverCoordinates = Coordinate(
                      latitude: globalFoundPlace.latitude,
                      longitude: globalFoundPlace.longitude,
                    );
                    final stopover = Stopover(
                      cityName: globalFoundPlace.cityName,
                      latitude: selectedStopoverCoordinates.latitude,
                      longitude: selectedStopoverCoordinates.longitude,
                      // "!" because if they're here in the code, this won't be null
                      arrivalDate: _startDate!,
                      departureDate: _endDate!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(
                            context,
                          )!.stopoverSuccessfullyAdded,
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context, stopover);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
