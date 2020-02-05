import 'package:flutter/material.dart';
import 'package:mdp_weather/models/my_weather.dart';
import 'package:provider/provider.dart';
import 'package:mdp_weather/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(ChangeNotifierProvider(
    builder: (context) {
      return MyWeatherModel(
        prefs.getBool('tempIsC') ?? true,
        prefs.getBool('distanceIsKm') ?? true,
        prefs.getBool('precipIsMm') ?? true,
        prefs.getBool('pressureIsMb') ?? true,
      );
    },
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mdp Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
        accentColor: Color(0xff5cfa7f),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
