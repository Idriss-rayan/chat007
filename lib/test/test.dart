import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountryDropdownAnimated extends StatefulWidget {
  const CountryDropdownAnimated({super.key});

  @override
  State<CountryDropdownAnimated> createState() =>
      _CountryDropdownAnimatedState();
}

class _CountryDropdownAnimatedState extends State<CountryDropdownAnimated> {
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: _showAnimatedCountryPicker,
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Sélectionnez un pays",
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                controller: TextEditingController(text: _selectedCountry),
                validator: (value) => value == null || value.isEmpty
                    ? "Veuillez choisir un pays"
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
