import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dribbbledanimation/api/reportApi.dart';
import 'package:dribbbledanimation/models/rapport.dart';
import 'package:dribbbledanimation/services/sendingReports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Cafe extends StatefulWidget {
  @override
  _CafeState createState() => _CafeState();
}

class _CafeState extends State<Cafe> {
  @override
  File im;
  Report report = new Report();
  var langu="Fr";

  Future getLocation() async {
    Location location = new Location();
    GoogleMapController mapController;
    Marker marker;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }
    _locationData = await location.getLocation();
    print(_locationData);
    print(DateTime.now());
    setState(() {
    });
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      im = image;
    });
  }

  Future setImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      im = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    TextEditingController textEditingController1 = new TextEditingController();

    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
          child: langu == "Fr"
              ? Image.asset(
                  "assets/france.jpg",
                  width: deviceWidth * 0.1,
                )
              : Image.asset(
                  "assets/tunisie.png",
                  width: deviceWidth * 0.1,
                ),
          onPressed: () {
            print("Button clicked");
            if (langu == "Fr") {
              setState(() {
                langu = "Ar";
              });
            } else {
              setState(() {
                langu = "Fr";
              });
            }
          },
          backgroundColor: Colors.grey,
        ),
            backgroundColor: Color.fromRGBO(250, 205, 211, 1),
            appBar: AppBar(
              centerTitle: true,
              title: Text(langu=="Fr" ? 'Veuillez prendre une photo': "يرجى التقاط صورة",
                  style: TextStyle(color: Colors.white)),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color.fromRGBO(162, 146, 199, 0.8),
                      Colors.pink[100],
                      Color.fromRGBO(51, 51, 63, 0.9)
                    ],
                  ),
                ),
              ),
            ),
            body: ListView(children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: deviceHeight * 0.4,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/cafe.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
              ]),
              SizedBox(height: deviceHeight * 0.01),
              Container(
                  width: 300,
                  child: TextFormField(
                    onChanged: (String value) {
                      setState(() {
                        report.description = value;
                      });
                    },
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      border: OutlineInputBorder(),
                      labelText: langu=="Fr" ? 'Ajouter une description': "إضافة وصف",
                      labelStyle: new TextStyle(
                        color: const Color(0xFF424242),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: langu=="Fr" ? 'Ajouter une description': "إضافة وصف",
                    ),
                    autofocus: false,
                  )),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(langu=="Fr" ? 'Ajouter une photo': "إضافة صورة"),
                  Text(langu=="Fr" ? 'Importer une photo': "استيراد صورة"),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child:Icon(Icons.camera_alt, size: 50.0),
                          height: 50,
                          width: 50,
                        )),
                    GestureDetector(
                        onTap: () {
                          setImage();
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child:  Icon(Icons.file_upload, size: 50.0),
                          height: 50,
                          width: 50,
                        )),

                  ]),
              Container(
                  child: im ==null ?
                  Icon(Icons.sync):Image.file(im)),
              ButtonTheme(
                buttonColor: Colors.blueGrey,
                minWidth: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  splashColor: Colors.red,
                  onPressed: () async {
                
                    if (im == null) {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: langu=="Fr" ? 'Veuillez prendre une photo': "يرجى التقاط صورة",
                        buttons: [
                          DialogButton(
                              child: Text(langu=="Ar" ? 'Ok': "موافق"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ])),
                        ],
                      ).show();
                    } else {
                      Location location = new Location();
                      LocationData _locationData = await location.getLocation();
                      report.longitude = _locationData.longitude;
                      report.latitude = _locationData.latitude;
                      String base64Image = base64Encode(im.readAsBytesSync());
                      report.urlToImage = base64Image;
                      report.type = 'Cafe';
                      String currentTime = DateTime.now().toString();
                      report.time = currentTime;
                      var data = report.toJson();
                      var res = await CallApi().postData(data, 'rep');
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: langu=="Fr" ? 'Merci pour votre aide !': "أشكركم على مساعدتكم!",
                        desc: langu=="Ar" ? 'On vous souhaite santé et bien-être': "نتمنى لكم الصحة والرفاهية!",
                        buttons: [
                          DialogButton(
                              child: Text(langu=="Ar" ? 'Fermer': "اغلاق"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ])),
                        ],
                      ).show();
                    }
                  },
                  child: Text(langu=="Fr" ? 'Envoyer': "ارسال"),
                ),
              )
            ])));
  }
}
