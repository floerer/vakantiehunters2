import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'theme.dart';
import 'SizeConfig.dart';
import 'holidayinfo.dart';

//INFO SCREEN OF HOLIDAY
class ResultPage extends StatelessWidget {
  static ApiData api = new ApiData();
  int id;
  String name;

  ResultPage(int id, String name){
    this.id = id;
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
            title: 'Categoriën',
            theme: ThemeData(
              primarySwatch: themeColor,
            ),
            home: Scaffold(
                appBar: AppBar(
                  title: Text(
                    name,
                    style:
                    TextStyle(color: themeColor, fontWeight: FontWeight.bold),
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
                  future: api.getCategoryHolidays(id),
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

                    return ListView.builder(
                      //image - s.data[index]["images"][0]["src"]
                      //title - s.data[index]["name"]
                      //desc - s.data['description']
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
                )
            )
        );
      });
    });
  }
}