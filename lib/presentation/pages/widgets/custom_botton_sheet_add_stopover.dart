import 'dart:async';

import 'package:desafio_final_lincetech_academy/entities/coordinate.dart';
import 'package:desafio_final_lincetech_academy/entities/stopover.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/all_widgets.dart';
import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/custom_action_button.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/coordinates_state.dart';
import 'package:desafio_final_lincetech_academy/presentation/providers/stopover_state.dart';
import 'package:desafio_final_lincetech_academy/use_cases/geolocation/nominatim_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../entities/stopoverPlace.dart';

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
  String _searchText = '';

  //TEST AREA
  late Place globalFoundPlace;
  double defaultLat = 0;
  double defaultLon = 0;

  DateTime? _startDate;
  DateTime? _endDate;

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
                Center(child: CustomHeader(text: "Add Stopover", size: 20)),
                SizedBox(height: 20),

                CustomHeader(text: "City Name"),
                TextFormField(
                  controller: cityNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Enter name here..."),

                  /*Here each time the user types, the API searches the value on Nominatim API*/
                  onChanged: (String value) async {
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
                      ? Text("")
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: placeSuggestions.length,
                            itemBuilder: (context, index) {
                              final foundPlace = placeSuggestions[index];

                              return ListTile(
                                title: Text(
                                  "${foundPlace.cityName}, ${foundPlace.cityState},${foundPlace.cityCountry}",
                                ),
                                onTap: () {
                                  cityNameController.text =
                                      '${foundPlace.cityName}, ${foundPlace.cityState}, ${foundPlace.cityCountry}';
                                  globalFoundPlace =
                                      foundPlace; //TODO: That's a test, delete later
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

                CustomExperienceList(),
                SizedBox(height: 30),

                CustomActionButton(
                  text: "Add Stopover",
                  onPressed: () {
                    final selectedStopoverCoordinates = Coordinate(
                      latidude: globalFoundPlace.latitude,
                      longitude: globalFoundPlace.longitude,
                    );
                    final selectedStopover = Stopover(
                      cityName: globalFoundPlace.cityName,
                      coordinates: selectedStopoverCoordinates,
                      // "!" because if they're here in the code, this won't be null
                      arrivalDate: _startDate!,
                      departureDate: _endDate!,
                    );
                    Provider.of<StopoverProvider>(
                      context,
                      listen: false,
                    ).addStopover(selectedStopover);
                    print("ççççççççççç");
                    print(
                      "${selectedStopover.cityName} foi adicionado na playlist",
                    );
                    print(StopoverProvider().stopoverList.length);
                    Navigator.pop(context);
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
