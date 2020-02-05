import 'package:flutter/material.dart';
import 'package:mdp_weather/pages/about.dart';
import 'package:mdp_weather/models/my_weather.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyWeatherModel>(context);

    return Drawer(
      child: Stack(
        children: <Widget>[
          DrawerBackground(),
          Column(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment(0.0, -0.5),
                  child: Text(
                    'Weather App',
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .apply(color: Colors.white),
                  ),
                ),
              ),
              UnitSwitchTile(
                title: 'Temperature',
                left: '°F',
                right: '°C',
                active: myProvider.tempIsC,
                onChanged: (bool value) {
                  myProvider.tempIsC = value;
                },
              ),
              UnitSwitchTile(
                title: 'Distance',
                left: 'miles',
                right: 'km',
                active: myProvider.distanceIsKm,
                onChanged: (bool value) {
                  myProvider.distanceIsKm = value;
                },
              ),
              UnitSwitchTile(
                title: 'Precipitation',
                left: 'in',
                right: 'mm',
                active: myProvider.precipIsMm,
                onChanged: (bool value) {
                  myProvider.precipIsMm = value;
                },
              ),
              UnitSwitchTile(
                title: 'Pressure',
                left: 'in',
                right: 'mb',
                active: myProvider.pressureIsMb,
                onChanged: (bool value) {
                  myProvider.pressureIsMb = value;
                },
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    spreadRadius: -30.0,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 7.0),
                    color: Colors.grey[800].withAlpha(100),
                  )
                ]),
                child: RaisedButton(
                  color: Color.fromRGBO(78, 217, 109, 1.0),
                  textColor: Colors.white,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.info_outline),
                        Text(
                          'About',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UnitSwitchTile extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool active;
  final String title;
  final String left;
  final String right;

  UnitSwitchTile({
    @required this.title,
    @required this.active,
    @required this.onChanged,
    @required this.left,
    @required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: FlatButton(
              color: active
                  ? HSLColor.fromColor(Theme.of(context).accentColor)
                      .withSaturation(0.3)
                      .toColor()
                  : Theme.of(context).accentColor,
              padding: EdgeInsets.zero,
              shape: Border(),
              child: Text(
                left,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
              onPressed: () {
                onChanged(false);
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              color: active
                  ? Theme.of(context).accentColor
                  : HSLColor.fromColor(Theme.of(context).accentColor)
                      .withSaturation(0.3)
                      .toColor(),
              padding: EdgeInsets.zero,
              shape: Border(),
              child: Text(
                right,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
              onPressed: () {
                onChanged(true);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color.fromRGBO(70, 199, 98, 0.6), // firstColor
              HSLColor.fromColor(Theme.of(context).accentColor)
                  .withSaturation(0.54)
                  .withLightness(0.53)
                  .toColor()
                  .withOpacity(0.6),
              // Color.fromRGBO(78, 217, 109, 0.8), // secondColor
              HSLColor.fromColor(Theme.of(context).accentColor)
                  .withSaturation(0.65)
                  .withLightness(0.58)
                  .toColor()
                  .withOpacity(0.8),
              // Color.fromRGBO(48, 138, 68, 0.6), // thirdColor
              HSLColor.fromColor(Theme.of(context).accentColor)
                  .withSaturation(0.48)
                  .withLightness(0.36)
                  .toColor()
                  .withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Just change this value to raise/lower the curve
    final double bottomLine = 120.0;
    path.lineTo(0.0, size.height - bottomLine);

    var firstEndPoint = Offset(size.width * 0.5, size.height - bottomLine + 50);
    var firstControlPoint =
        Offset(size.width * 0.25, size.height - bottomLine + 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - bottomLine);
    var secondControlPoint =
        Offset(size.width * 0.75, size.height - bottomLine + 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
