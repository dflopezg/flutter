import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_gallery/flutter_camera_gallery.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _articleName = '';

  Future _scanBarcode() async {
    try {
      String barcode = await BarcodeScanner.scan();
      String articleName = await searchArticleName(barcode);
      setState(() {
        _articleName = articleName;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _articleName = 'Camera permission denied';
        });
      } else {
        setState(() {
          _articleName = 'Error: $e';
        });
      }
    } on FormatException {
      setState(() {
        _articleName = 'Scan canceled';
      });
    } catch (e) {
      setState(() {
        _articleName = 'Error: $e';
      });
    }
  }

  Future<String> searchArticleName(String barcode) async {
    String articleName;
    String jsonString = await DefaultAssetBundle.of(context).loadString('assets/articles.json');
    List<dynamic> articles = json.decode(jsonString);
    for (var article in articles) {
      if (article['barcode'] == barcode) {
        articleName = article['name'];
        break;
      }
    }
    return articleName;
  }

  Future _takePhotos() async {
    List<dynamic> result = await FlutterCameraGallery.startCamera(
      cameraFlashMode: CameraFlashMode.off,
      shouldCrop: false,
      imageCount: 5,
    );
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Article Name:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _articleName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            RaisedButton(
              child: Text('Scan Barcode'),
              onPressed: _scanBarcode,
            ),
            RaisedButton(
              child: Text('Take Photos'),
              onPressed: _takePhotos,
            ),
          ],
        ),
      ),
    );
  }
}

//Este es un código para revisión
//Lo más seguros es que debe reescribirse el código
//Se ha creado un ticket para la modificación del código
