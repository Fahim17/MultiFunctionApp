import 'package:flutter/material.dart';
import 'package:multifuncapp/crud_ui.dart';
import 'package:multifuncapp/notification_api.dart';
import 'package:multifuncapp/webview_api.dart';
import 'package:sqflite/sqflite.dart';
import 'barcode_api.dart';
import 'crud_ui_firebase.dart';
import 'gmap_api.dart';
import 'location_api.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Function App"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      List latlng = locApi.currentlocation();
                      //print(latlng);
                      if (latlng.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GMap(
                                    latlng: latlng,
                                  )),
                        );
                      }
                    },
                    child: const Text(
                      'Map',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      String code = await BarScanApi.scanB();
                      final snackBar = SnackBar(
                        content: Text('Barcode: $code'),
                        duration: const Duration(seconds: 10),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Text(
                      'Barcode',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //row one end
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CrudModel()),
                      );
                    },
                    child: const Text(
                      'SqliteDB',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CRUDModelFB()),
                      );
                    },
                    child: const Text(
                      'Firebase',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //row 2 end
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WView()),
                      );
                    },
                    child: const Text(
                      'Web View',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: NotificationAPI()),
              ),
            ],
          ),
          //row 3 end
        ],
      ),
    );
  }
}
