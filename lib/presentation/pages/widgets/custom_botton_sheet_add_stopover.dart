import 'package:desafio_final_lincetech_academy/presentation/pages/widgets/all_widgets.dart';
import 'package:desafio_final_lincetech_academy/use_cases/geolocation/nominatim_service.dart';
import 'package:flutter/material.dart';

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
                    final places = await searchPlace(value);
                    placeSuggestions.clear(); //Cleaning the suggestions list
                    /* For each element in places, we will create an object "Place"*/
                    for (var value in places) {
                      final place = Place.fromJson(value);
                      print(place);
                      placeSuggestions.add(place);
                    }
                    print(placeSuggestions);
                    setState(() {});
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
                                  "${foundPlace.cityName}, ${foundPlace.cityCountry}",
                                ),
                              );
                            },
                          ),
                        ),
                ),

                CustomDatePicker(),
                SizedBox(height: 30),

                CustomExperienceList(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
