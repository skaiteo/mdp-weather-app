import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-1.0, -1.2),
            radius: 1.5,
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
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: [0.6, 0.8, 1.0, 1.0],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'About Us',
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .apply(color: Colors.white, fontWeightDelta: 3),
                ),
              ),
            ),
            _card(context, 'BC', 'Bryan Chan Zhen Han', 'B02170020'),
            _card(context, 'JY', 'Justine Yong Jia Hao', 'B02170022'),
            _card(context, 'MI', 'Muhammad Imran bin Mohd Azmi', 'B02170023'),
            _card(context, 'TL', 'Timothy Low Keng Hau', 'B02170025'),
            _card(context, 'SK', 'Teo Sheng Kai', 'B02170026'),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget _card(
      BuildContext context, String initials, String name, String studentID) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(17.0, 2.0, 24.0, 2.0),
          leading: CircleAvatar(
            child: Text(
              initials,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromRGBO(78, 217, 109, 0.9),
          ),
          title: Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(studentID, textAlign: TextAlign.end),
        ),
      ),
    );
  }
}
