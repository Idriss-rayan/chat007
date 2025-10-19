import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class Country extends StatefulWidget {
  final TextEditingController? controller;
  const Country({super.key, this.controller});

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Initialiser avec la valeur du controller si elle existe
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _selectedCountry = widget.controller!.text;
    }
  }

  void _showAnimatedCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (country) {
        setState(() {
          _selectedCountry = country.name;
        });
        // Mettre à jour le controller externe si fourni
        if (widget.controller != null) {
          widget.controller!.text = country.name;
        }
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(12),
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.black87),
        bottomSheetHeight: 500,
        inputDecoration: InputDecoration(
          labelText: 'Rechercher un pays',
          prefixIcon: const Icon(Icons.search),
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
            const SizedBox(height: 5),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(5, 255, 109, 64),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  controller:
                      TextEditingController(text: _selectedCountry ?? ''),
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
