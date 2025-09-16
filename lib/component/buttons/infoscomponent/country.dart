import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class Country extends StatefulWidget {
  const Country({super.key});

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  String? _selectedCountry;

  void _showAnimatedCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (country) {
        setState(() {
          _selectedCountry = country.name;
        });
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(12),
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, color: Colors.black87),
        bottomSheetHeight: 500,
        inputDecoration: InputDecoration(
          labelText: 'Rechercher un pays',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Country',
                  style: TextStyle(
                    color: const Color.fromARGB(128, 0, 0, 0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: _showAnimatedCountryPicker,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(5, 255, 109, 64),
                      ),
                    ),
                    labelText: " ",
                    //prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(5, 255, 109, 64),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  controller: TextEditingController(text: _selectedCountry),
                  validator: (value) => value == null || value.isEmpty
                      ? "Veuillez choisir un pays"
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
