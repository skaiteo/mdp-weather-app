import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MyCurrentWeather {
  String locationName;
  String locationRegion;
  String locationCountry;
  double locationLat;
  double locationLon;
  String locationTzid;
  String locationLocaltime;
  String currentLastUpdated;
  double currentTempc;
  double currentTempf;
  String currentConditionText;
  String currentConditionIcon;
  int currentConditionCode;
  double windmph;
  double windkph;
  int winddegree;
  String winddir;
  double pressuremb;
  double pressurein;
  double precipmm;
  double precipin;
  int humidity;
  int cloud;
  double feelslikec;
  double feelslikef;
  double viskm;
  double vismiles;
  double uv;
  double gustmph;
  double gustkph;

  MyCurrentWeather();
  MyCurrentWeather.fromJson(Map<String, dynamic> json)
      : locationName = json['location']['name'] ?? null,
        locationRegion = json['location']['region'] ?? null,
        locationCountry = json['location']['country'] ?? null,
        locationLat = json['location']['lat'] ?? null,
        locationLon = json['location']['lon'] ?? null,
        locationTzid = json['location']['tz_id'] ?? null,
        locationLocaltime = json['location']['localtime'] ?? null,
        currentLastUpdated = json['current']['last_updated'] ?? null,
        currentTempc = json['current']['temp_c'] ?? null,
        currentTempf = json['current']['temp_f'] ?? null,
        currentConditionText = json['current']['condition']['text'] ?? null,
        currentConditionIcon = json['current']['condition']['icon'] ?? null,
        currentConditionCode = json['current']['condition']['code'] ?? null,
        windmph = json['current']['wind_mph'] ?? null,
        windkph = json['current']['wind_kph'] ?? null,
        winddegree = json['current']['wind_degree'] ?? null,
        winddir = json['current']['wind_dir'] ?? null,
        pressuremb = json['current']['pressure_mb'] ?? null,
        pressurein = json['current']['pressure_in'] ?? null,
        precipmm = json['current']['precip_mm'] ?? null,
        precipin = json['current']['precip_in'] ?? null,
        humidity = json['current']['humidity'] ?? null,
        cloud = json['current']['cloud'] ?? null,
        feelslikec = json['current']['feelslike_c'] ?? null,
        feelslikef = json['current']['feelslike_f'] ?? null,
        viskm = json['current']['vis_km'] ?? null,
        vismiles = json['current']['vis_miles'] ?? null,
        uv = json['current']['uv'] ?? null,
        gustmph = json['current']['gust_mph'] ?? null,
        gustkph = json['current']['gust_kph'] ?? null;
}

class MyForecastWeather {
  String date;
  double maxtempc;
  double maxtempf;
  double mintempc;
  double mintempf;
  double avgtempc;
  double avgtempf;
  double maxwindmph;
  double maxwindkph;
  double totalprecipmm;
  double totalprecipin;
  double avgviskm;
  double avgvismiles;
  double avghumidity;
  String conditionText;
  String conditionIcon;
  int conditionCode;
  double uv;
  String astroSunrise;
  String astroSunset;
  String astroMoon;
  String astroMoonset;
  MyForecastWeather.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    maxtempc = json['day']['maxtemp_c'];
    maxtempf = json['day']['maxtemp_f'];
    mintempc = json['day']['mintemp_c'];
    mintempf = json['day']['mintemp_f'];
    avgtempc = json['day']['avgtemp_c'];
    avgtempf = json['day']['avgtemp_f'];
    maxwindmph = json['day']['maxwind_mph'];
    maxwindkph = json['day']['maxwind_kph'];
    totalprecipmm = json['day']['totalprecip_mm'];
    totalprecipin = json['day']['totalprecip_in'];
    avgviskm = json['day']['avgvis_km'];
    avgvismiles = json['day']['avgvis_miles'];
    avghumidity = json['day']['avghumidity'];
    conditionText = json['day']['condition']['text'];
    conditionIcon = json['day']['condition']['icon'];
    conditionCode = json['day']['condition']['code'];
    uv = json['day']['uv'];
    astroSunrise = json['astro']['sunrise'];
    astroSunset = json['astro']['sunset'];
    astroMoon = json['astro']['moonrise'];
    astroMoonset = json['astro']['moonset'];
  }
}

class MySearch {
  int id;
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String url;

  MySearch();

  MySearch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    country = json['country'];
    lat = json['lat'];
    lon = json['lon'];
    url = json['url'];
  }
}

class MyWeatherModel extends ChangeNotifier {
  MyWeatherModel(bool tempIsC, bool distanceIsKm, bool precipIsMm, bool pressureIsMb){
    _tempIsC = tempIsC;
    _distanceIsKm = distanceIsKm;
    _precipIsMm = precipIsMm;
    _pressureIsMb = pressureIsMb;
    fetch();
  }
  String _currLocation = 'Kuala Lumpur';
  
  MyCurrentWeather _weather;
  List<MyForecastWeather> _forecast = [];
  List<MySearch> _option = [];

  MyCurrentWeather get weather => _weather;
  List<MyForecastWeather> get forecast => _forecast;
  List<MySearch> get searchOption => _option;

  /* Unit conversion states */
  bool _tempIsC = true; // false means Fahrenheit
  bool get tempIsC => _tempIsC;
  set tempIsC(bool value) {
    _tempIsC = value;
    notifyListeners();
  }
  
  bool _distanceIsKm = true; // false means KM
  bool get distanceIsKm => _distanceIsKm;
  set distanceIsKm(bool value) {
    _distanceIsKm = value;
    notifyListeners();
  }
  
  bool _precipIsMm = true; // false means in (inches)
  bool get precipIsMm => _precipIsMm;
  set precipIsMm(bool value) {
    _precipIsMm = value;
    notifyListeners();
  }

  bool _pressureIsMb = true;  // millibars, false means in (inches)
  bool get pressureIsMb => _pressureIsMb;
  set pressureIsMb(bool value) {
    _pressureIsMb = value;
    notifyListeners();
  }
  /* END Unit conversion states */

  fetch([String searchLocation]) async {
    print('fetch');
    _weather = null;
    _forecast = [];
    notifyListeners();
    _currLocation = searchLocation ?? _currLocation;
    Map<String, dynamic> weathersMap =
        await fetchWeathers(http.Client(), searchLocation ?? _currLocation);
    _weather = MyCurrentWeather.fromJson(weathersMap);
    for (var i = 0; i < weathersMap['forecast']['forecastday'].length; i++) {
      _forecast.add(MyForecastWeather.fromJson(
          weathersMap['forecast']['forecastday'][i]));
    }
    print('fetch done');
    notifyListeners();
  }

  search([String userInput = 'Kuala Lumpur']) async {
    print('searching');
    _option = [];
    List<dynamic> searchmap = await fetchSearch(http.Client(), userInput);
    for (var i = 0; i < searchmap.length; i++) {
      _option.add(MySearch.fromJson(searchmap[i]));
    }
    return _option;
  }
}

fetchSearch(http.Client client, String location) async {
  String apikey = '076c33a42a884a5297954411192807';
  http.Response response = await client
      .get('http://api.apixu.com/v1/search.json?key=${apikey}&q=${location}');
  return jsonDecode(response.body);
}

fetchWeathers(http.Client client, String location) async {
  String apikey = '076c33a42a884a5297954411192807';
  http.Response response = await client.get(
      'http://api.apixu.com/v1/forecast.json?key=${apikey}&q=${location}&days=10');
  return jsonDecode(response.body);
}
