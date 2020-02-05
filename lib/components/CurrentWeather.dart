import 'package:flutter/material.dart';
import 'package:mdp_weather/models/my_weather.dart';
import 'package:provider/provider.dart';
import "dart:math" as math;

class CurrentWeather extends StatefulWidget {
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  @override
  Widget build(BuildContext context) {
    var currTemp = Provider.of<MyWeatherModel>(context);
    var feelsLike = currTemp.tempIsC
        ? '${currTemp.weather.feelslikec}°C'
        : '${currTemp.weather.feelslikef}°F';
    var wind = currTemp.distanceIsKm
        ? currTemp.weather.windkph
        : currTemp.weather.windmph;
    var pressure = currTemp.pressureIsMb
        ? '${currTemp.weather.pressuremb} mBar'
        : '${currTemp.weather.pressurein} in';
    var visibility = currTemp.distanceIsKm
        ? '${currTemp.weather.viskm} km'
        : '${currTemp.weather.vismiles} miles';
    var gust = currTemp.distanceIsKm
        ? '${currTemp.weather.gustkph} km/h'
        : '${currTemp.weather.gustmph} miles/h';
    var precip = currTemp.precipIsMm
        ? currTemp.weather.precipmm
        : currTemp.weather.precipin;
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            _card(_condition(currTemp.weather.currentConditionText,
                currTemp.weather.currentConditionIcon, feelsLike)),
            _card(_wind(wind, currTemp.distanceIsKm, currTemp.weather.winddir,
                currTemp.weather.winddegree)),
            _card(_currentDetails("Humidity", "${currTemp.weather.humidity}")),
            _card(_currentDetails("Pressure", "$pressure")),
            _card(_currentDetails("UV Index", "${currTemp.weather.uv}")),
            _card(_currentDetails("Visibility", "$visibility")),
            _card(_currentDetails("Gust", "$gust")),
            _card(_precipitation(precip, currTemp.precipIsMm)),
          ],
        ),
      ),
    );
  }
}

Widget _currentDetails(String category, String details) {
  return Padding(
    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(category,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
        Text(details,
            textAlign: TextAlign.end,
            style: TextStyle(
                fontFamily: "Montserrat", fontSize: 20.0, color: Colors.grey)),
      ],
    ),
  );
}

Widget _condition(String cond, String picture, String feelsLike) {
  List<String> _parsed = picture.split('/');
  return Padding(
    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Image.asset(
                    'assets/icons/${_parsed[_parsed.length - 2]}/${_parsed[_parsed.length - 1]}'),
              ),
              Text(
                cond,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "Feels Like:",
                style: TextStyle(
                    fontFamily: "Montserrat", fontWeight: FontWeight.bold),
              ),
              Text(
                "$feelsLike",
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "Montserrat",
                    color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _precipitation(double precipitation, bool isMm) {
  return Padding(
    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Precipitation",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            isMm
                ? Text(
                    "$precipitation mm",
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  )
                : Text(
                    "$precipitation in",
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                width: 20,
                height: precipitation * 20,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              ),
            )
          ],
        ),
      ],
    ),
  );
}

Widget _wind(double wind, bool isMph, String windDir, int windDegree) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: Text(
          "Wind",
          style:
              TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold),
        ),
      ),
      Row(
        children: <Widget>[
          Text("$wind",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.blueAccent,
                  fontSize: 30)),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Transform.rotate(
                  angle: windDegree.toDouble() * math.pi / 180.0,
                  child: Icon(
                    Icons.navigation,
                    color: Colors.blueGrey,
                  ),
                ),
                isMph
                    ? Text(
                        "km/h",
                        style: TextStyle(fontFamily: "Montserrat"),
                      )
                    : Text(
                        "miles/h",
                        style: TextStyle(fontFamily: "Montserrat"),
                      )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Wind Direction",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$windDir",
                    style: TextStyle(fontFamily: "Montserrat"),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    ],
  );
}

Widget _card(Widget widget) {
  return Container(
    margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
    child: Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: widget,
      ),
    ),
  );
}
