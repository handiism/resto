import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Currency extends StatefulWidget {
  const Currency({super.key});

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  String currencyInput = 'IDR';
  String currencyOutput = 'IDR';
  String result = '0';

  TextEditingController controller = TextEditingController(text: "0");

  void onSubmitted(String value) async {
    var res = await http.get(
      Uri.parse(
          "https://api.apilayer.com/exchangerates_data/convert?to=$currencyOutput&from=$currencyInput&amount=$value"),
      headers: {
        "apikey": "ljjJnXvH8EoNX32Rht9kr7cwuifUkiCI",
      },
    );

    var json = await jsonDecode(res.body);

    setState(() {
      result = json["result"].toString();
    });
  }

  void onCurrencyInputChanged(String? value) async {
    var url =
        "https://api.apilayer.com/exchangerates_data/convert?to=$currencyOutput&from=$value&amount=${controller.text.toString()}";

    var res = await http.get(
      Uri.parse(url),
      headers: {
        "apikey": "ljjJnXvH8EoNX32Rht9kr7cwuifUkiCI",
      },
    );

    var json = await jsonDecode(res.body);

    setState(() {
      currencyInput = value ?? "IDR";
      result = json["result"].toString();
    });
  }

  void onCurrencyOutputChanged(String? value) async {
    var url =
        "https://api.apilayer.com/exchangerates_data/convert?to=$value&from=$currencyInput&amount=${controller.text.toString()}";

    var res = await http.get(
      Uri.parse(url),
      headers: {
        "apikey": "ljjJnXvH8EoNX32Rht9kr7cwuifUkiCI",
      },
    );

    var json = await jsonDecode(res.body);

    setState(() {
      currencyOutput = value ?? "IDR";
      result = json["result"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Uang',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: TextField(
                          controller: controller,
                          // onSubmitted: onSubmitted,
                          onSubmitted: onSubmitted,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton(
                        value: currencyInput,
                        items: const <String>['IDR', 'USD', 'EUR']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: onCurrencyInputChanged,
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ke',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: TextField(
                          enabled: false,
                          controller: TextEditingController(text: result),
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton(
                        value: currencyOutput,
                        items: const <String>['IDR', 'USD', 'EUR']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: onCurrencyOutputChanged,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
