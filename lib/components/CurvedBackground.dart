import 'package:flutter/material.dart';

import 'package:mdp_weather/components/CustomShapeClipper.dart';
import 'package:mdp_weather/models/my_weather.dart';
import 'package:mdp_weather/pages/searchPage.dart';
import 'package:provider/provider.dart';

const firstColor = const Color.fromRGBO(70, 199, 98, 0.6);
const secondColor = const Color.fromRGBO(78, 217, 109, 0.8);
const thirdColor = const Color.fromRGBO(48, 138, 68, 0.6);

class CurvedBackground extends StatefulWidget {
  @override
  _CurvedBackground createState() => _CurvedBackground();
}

class _CurvedBackground extends State<CurvedBackground> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var myWeather = Provider.of<MyWeatherModel>(context);
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: 500.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [firstColor, secondColor, thirdColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: FlexibleSpaceBar(
          title: Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Text(
              '${myWeather.weather.locationName}',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
          centerTitle: true,
          collapseMode: CollapseMode.pin,
          background: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.fromLTRB(40.0, 100, 40.0, 0.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          enabled: false,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 220.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${myWeather.weather.currentConditionText}',
                            style:
                                TextStyle(fontSize: 26.0, color: Colors.white),
                          ),
                          Text(
                            myWeather.tempIsC
                                ? '${myWeather.weather.currentTempc.toInt()}°C'
                                : '${myWeather.weather.currentTempf.toInt()}°F',
                            style: TextStyle(
                                fontSize: 100.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
