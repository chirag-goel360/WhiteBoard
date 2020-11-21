import 'dart:ui';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:whiteboardkit/whiteboardkit.dart';

void main(){
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'White Board',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DrawingController controller;
  GlobalKey globalKey = new GlobalKey();

  @override
  void initState() {
    controller = new DrawingController();
    controller.onChange().listen((draw){
    },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "White Board",
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: sharecode,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  color: Colors.white,
                  child: Whiteboard(
                    controller: controller,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sharecode() async{
    try{
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var item = await boundary.toImage();
      ByteData byteData = await item.toByteData(
        format: ImageByteFormat.png,
      );
      await Share.file(
        'esys image',
        'image.png',
        byteData.buffer.asUint8List(),
        'image/png',
      );
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}