import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'theme.dart';
import 'SizeConfig.dart';

//INFO SCREEN OF HOLIDAY
class HolidayInfo extends StatelessWidget {
  static ApiData api = new ApiData();
  int id;
  List<Widget> imageWidgetList = new List<Widget>();

  //constructor for id
  HolidayInfo(id) {
    this.id = id;
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  void addImages(AsyncSnapshot s){
    for(int i = s.data["images"].length - 1; i >= 0; i--){
      imageWidgetList.add(Image.network(
        s.data["images"][i]["src"],
        fit: BoxFit.contain,
        height: 100 * SizeConfig.imageSizeMultiplier,
        width: 100 * SizeConfig.imageSizeMultiplier,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
          title: 'Vakantie',
          theme: ThemeData(
            primarySwatch: themeColor,
          ),
          home: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Vakantie',
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
                  addImages(s);
                return Column(
                  children: <Widget>[
                    Stack(overflow: Overflow.visible, children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 10 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                      Container(
                        height: 35 * SizeConfig.heightMultiplier,
                        width: 100 * SizeConfig.widthMultiplier,
                        child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: imageWidgetList
                        ),
                      ),
                      Positioned(
                        top: 30 * SizeConfig.heightMultiplier,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 70 * SizeConfig.heightMultiplier,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 50.0, bottom: 20.0),
                                child: Text(
                                  s.data["name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          3 * SizeConfig.textMultiplier,
                                      fontFamily: 'OpenSans'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  s.data["categories"][0]["name"] +
                                      ", " +
                                      s.data["categories"][1]["name"],
                                  style: TextStyle(
                                      color: themeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          2.5 * SizeConfig.textMultiplier,
                                      fontFamily: 'OpenSans'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 20.0),
                                child: Text(
                                  removeAllHtmlTags(s.data["description"]),
                                  style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          1.8 * SizeConfig.textMultiplier,
                                      fontFamily: 'OpenSans'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 30.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '€' + s.data["sale_price"],
                                                style: TextStyle(
                                                    color: themeColor,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 4 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontFamily:
                                                        'OpenSans-Bold'),
                                              ),
                                              Text(
                                                '€' +
                                                    s.data["regular_price"],
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontFamily:
                                                        'OpenSans-Bold',
                                                    decoration:
                                                        TextDecoration
                                                            .lineThrough),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Je bespaart : " +
                                                ((double.parse(s.data[
                                                                "sale_price"]) -
                                                            double.parse(s
                                                                    .data[
                                                                "regular_price"])) /
                                                        double.parse(s.data[
                                                            "regular_price"]) *
                                                        100)
                                                    .floor()
                                                    .toString() +
                                                "%",
                                            style: TextStyle(
                                                color: themeColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 1.7 *
                                                    SizeConfig
                                                        .textMultiplier,
                                                fontFamily:
                                                    'OpenSans-Bold'),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 3 * SizeConfig.heightMultiplier,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: themeColor),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3 * SizeConfig.widthMultiplier,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: themeColor),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.wb_sunny,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 1 *
                                                    SizeConfig
                                                        .widthMultiplier,
                                              ),
                                              Text(
                                                "Bekijk Beschikbaarheid",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontFamily:
                                                        'OpenSans-Bold'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ])
                  ],
                );
              })),
        );
      });
    });
  }
}
