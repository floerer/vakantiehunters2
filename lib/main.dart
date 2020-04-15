import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'api.dart';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VakantieHunters Demo',
      home: MyHomePage(title: 'VakantieHunters'),
    );
  }
}

//INFO SCREEN OF HOLIDAY
class HolidayInfo extends StatelessWidget {
  static ApiData api = new ApiData();
  int id;

  //constructor for id
  HolidayInfo(id){
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vakantie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Vakantie',
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: themeColor,
              ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
            future: api.getHoliday(id),
            builder: (_, s) {
              if (s.data == null) {
                return Container(
                  child: Center(
                    child: SpinKitDoubleBounce(
                      color: themeColor,
                      size: 50.0,
                    ),
                  ),
                );
              }
              return Container(
                child: Card(
                  child: new Column(children: <Widget>[
                    new Container(
                      width: 500,
                      height: 300,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage(s.data['images'][0]['src']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    new Container(
                      child: Text(s.data['name']),
                    ),
                    new Container(
                      child:
                      Text(s.data['description'] + s.data['external_url']),
                    )
                  ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static ApiData api = new ApiData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      //PAGES IN THE APP
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(_selectedIndex),
        ),
      ),
      //NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 500),
                tabBackgroundColor: themeColor,
                tabs: [
                  GButton(
                    icon: Icons.wb_sunny,
                    text: 'Vakanties',
                  ),
                  GButton(
                    icon: Icons.pin_drop,
                    text: 'Bestemming',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'Favorieten',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Instellingen',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return FutureBuilder(
          future: api.getHolidays(),
          builder: (_, s) {
            if (s.data == null) {
              return Container(
                child: SpinKitDoubleBounce(
                  color: themeColor,
                  size: 50.0,
              ),
              );
            }

            return ListView.builder(
                itemCount: s.data.length,
                itemBuilder: (_, index) {
                  /// create a list of products
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.fromLTRB(4, 7, 4, 7),
                    child: ListTile(
                      onTap: () {
                        int holidayId = s.data[index]["id"];
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HolidayInfo(holidayId)),
                        );
                      },
                      leading: CircleAvatar(
                        child: Image.network(s.data[index]["images"][0]["src"]),
                        radius: 30,
                        backgroundColor: themeColor,
                      ),
                      title: Text(s.data[index]["name"]),
                      subtitle:
                          Text("Buy now for \$ " + s.data[index]["price"]),
                    ),
                  );
                });
          },
        );
      case 1:
        return Text(
          'Index 2: test',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        );
      case 2:
        return Text(
          'Index 3: hello',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        );
      case 2:
        return Text(
          'Index 4: doei',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        );
    }
  }
}

//Color for app, this is the main greenish color
MaterialColor themeColor = MaterialColor(0xFF5EB936, color);

Map<int, Color> color = {
  50: Color.fromRGBO(94, 185, 54, .1),
  100: Color.fromRGBO(94, 185, 54, .2),
  200: Color.fromRGBO(94, 185, 54, .3),
  300: Color.fromRGBO(94, 185, 54, .4),
  400: Color.fromRGBO(94, 185, 54, .5),
  500: Color.fromRGBO(94, 185, 54, .6),
  600: Color.fromRGBO(94, 185, 54, .7),
  700: Color.fromRGBO(94, 185, 54, .8),
  800: Color.fromRGBO(94, 185, 54, .9),
  900: Color.fromRGBO(94, 185, 54, 1),
};
