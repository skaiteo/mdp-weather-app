import 'package:flutter/material.dart';
import 'package:mdp_weather/models/my_weather.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MySevenDaysLayout extends StatefulWidget {
  @override
  _MySevenDaysLayoutState createState() => _MySevenDaysLayoutState();
}

class _MySevenDaysLayoutState extends State<MySevenDaysLayout> {
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyWeatherModel>(context);
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index.isEven) {
              return _forecastView(myProvider, index ~/ 2);
            }
            return Divider(height: 1.5);
          },
          childCount: myProvider.forecast.length * 2,
        ),
      ),
    );
  }

  Widget _forecastView(var myProvider, int index) {
    List<String> _parsed = myProvider.forecast[index].conditionIcon.split('/');
    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          index == 0
              ? Text('Today')
              : Text(DateFormat.yMMMMEEEEd().format(
                  DateTime.parse('${myProvider.forecast[index].date}'))),
          Text('${myProvider.forecast[index].conditionText}',
              style: TextStyle(color: Colors.grey)),
        ], //Condition Text
      ),
      trailing: AspectRatio(
        aspectRatio: 2 / 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Condition Icon
            Image.asset(
                'assets/icons/${_parsed[_parsed.length - 2]}/${_parsed[_parsed.length - 1]}'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                myProvider.tempIsC == true
                    ? Text('${myProvider.forecast[index].maxtempc}°C')
                    : Text('${myProvider.forecast[index].maxtempf}°F'),
                myProvider.tempIsC == true
                    ? Text(
                        '${myProvider.forecast[index].mintempc}°C',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text(
                        '${myProvider.forecast[index].mintempf}°F',
                        style: TextStyle(color: Colors.grey),
                      )
              ], // Max and Min Temperature
            )
          ],
        ),
      ),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Average Temperature',
                            style: TextStyle(color: Colors.grey)),
                        Text('Maximum Wind',
                            style: TextStyle(color: Colors.grey)),
                        Text('Average Humidity',
                            style: TextStyle(color: Colors.grey)),
                        Text('Total Precipitation',
                            style: TextStyle(color: Colors.grey)),
                        Text('UV Index', style: TextStyle(color: Colors.grey)),
                        Text('Average Visibility',
                            style: TextStyle(color: Colors.grey))
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      myProvider.tempIsC == true
                          ? Text('${myProvider.forecast[index].avgtempc}°C')
                          : Text(
                              '${myProvider.forecast[index].avgtempf}°F'), //Average Temperature Data
                      myProvider.distanceIsKm == true
                          ? Text('${myProvider.forecast[index].maxwindkph} kph')
                          : Text(
                              '${myProvider.forecast[index].maxwindmph} mph'), //Maximum Wind Data
                      Text(
                          '${myProvider.forecast[index].avghumidity}%'), //Average Humidity Data
                      myProvider.precipIsMm == true
                          ? Text(
                              '${myProvider.forecast[index].totalprecipmm} mm')
                          : Text(
                              '${myProvider.forecast[index].totalprecipin} inch'), //Total Precipitation Data
                      Text('${myProvider.forecast[index].uv}'), //UV Index Data
                      myProvider.distanceIsKm == true
                          ? Text('${myProvider.forecast[index].avgviskm} km')
                          : Text(
                              '${myProvider.forecast[index].avgvismiles} miles'), //Average Visibility Data
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text('View\nAstro',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  color: Color.fromRGBO(78, 217, 109, 1.0),
                  onPressed: () => _astroAlert(context, myProvider, index),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _astroAlert(context, var myProvider, int index) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      descStyle: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 18),
      isCloseButton: false,
      isOverlayTapDismiss: false,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(
          color: Colors.blue,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.blue,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    );
    return Alert(
        context: context,
        style: alertStyle,
        title: "ASTRO",
        desc: DateFormat.yMMMMEEEEd()
            .format(DateTime.parse('${myProvider.forecast[index].date}')),
        content: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Sunrise', style: TextStyle(color: Colors.grey)),
                  Text('Sunset', style: TextStyle(color: Colors.grey)),
                  Text('Moonrise', style: TextStyle(color: Colors.grey)),
                  Text('Moonset', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                      '${myProvider.forecast[index].astroSunrise}'), //Average Temperature Data
                  Text(
                      '${myProvider.forecast[index].astroSunset}'), //Maximum Wind Data
                  Text(
                      '${myProvider.forecast[index].astroMoon}'), //Average Humidity Data
                  Text('${myProvider.forecast[index].astroMoonset}'),
                ],
              )
            ],
          ),
        )).show();
  }
}
