import 'package:flutter/material.dart';
import 'package:mdp_weather/components/CustomShapeClipper.dart';
import 'package:mdp_weather/models/my_weather.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<MySearch> _searchResults;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<MyWeatherModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(70, 199, 98, 0.6),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 500.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(70, 199, 98, 0.6),
                    Color.fromRGBO(78, 217, 109, 0.8),
                    Color.fromRGBO(48, 138, 68, 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Search bar
          Container(
            padding: EdgeInsets.only(top: 10.0),
            margin: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    autofocus: true,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSubmitted: (String value) async {
                      setState(() {
                        _loading = true;
                      });
                      List<MySearch> results = await myProvider.search(value);
                      setState(() {
                        _searchResults = results;
                        _loading = false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: _searchBody(myProvider),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _searchBody(MyWeatherModel myProvider) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (_searchResults == null) {
      return null;
    } else if (_searchResults.length != 0) {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          MySearch _location = _searchResults[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                title: Text(
                  _location.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  'LAT: ${_location.lat} - LON: ${_location.lon}',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  myProvider.fetch(_location.url);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      );
    } else {
      return Text('No result :<');
    }
  }
}
