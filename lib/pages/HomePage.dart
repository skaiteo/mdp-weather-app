import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mdp_weather/models/my_weather.dart';
import 'package:mdp_weather/components/CurvedBackground.dart';
import 'package:mdp_weather/components/CurrentWeather.dart';
import 'package:mdp_weather/components/drawer.dart';
import 'package:mdp_weather/components/sevendays.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyWeatherModel>(context);
    if (myProvider.weather == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      var _tabs = [CurrentWeather(), MySevenDaysLayout()];
      return WillPopScope(
        onWillPop: () {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App?'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Color.fromRGBO(48, 138, 68, 0.9),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('tempIsC', myProvider.tempIsC);
                    await prefs.setBool(
                        'distanceIsKm', myProvider.distanceIsKm);
                    await prefs.setBool('precipIsMm', myProvider.precipIsMm);
                    await prefs.setBool(
                        'pressureIsMb', myProvider.pressureIsMb);
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Color.fromRGBO(48, 138, 68, 0.9),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: DefaultTabController(
          length: _tabs.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            drawer: AppDrawer(),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    child: SliverAppBar(
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            myProvider.fetch();
                          },
                        )
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(40.0),
                        child: Container(),
                      ),
                      expandedHeight: 500,
                      backgroundColor: Colors.white,
                      floating: false,
                      pinned: true,
                      elevation: 0.0,
                      flexibleSpace: CurvedBackground(),
                    ),
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    floating: false,
                    pinned: true,
                    elevation: 0.0,
                    flexibleSpace: Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TabBar(
                        indicatorColor: Color.fromRGBO(70, 199, 98, 0.6),
                        indicatorWeight: 5.0,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.black,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Montserrat'),
                        unselectedLabelStyle:
                            TextStyle(fontSize: 20.0, fontFamily: 'Montserrat'),
                        tabs: <Widget>[
                          Tab(text: 'Today'),
                          Tab(text: 'This Week'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: _tabs.map((Widget content) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            // This is the flip side of the SliverOverlapAbsorber above.
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          content,
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }
  }
}
