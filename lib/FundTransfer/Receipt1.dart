
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';


class Receipt2 extends StatefulWidget {
  const Receipt2({Key key}) : super(key: key);

  @override
  _Receipt2State createState() => _Receipt2State();
}

class _Receipt2State extends State<Receipt2> {
  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Receipt1"),
        ),
          body: Column(
            children: [
              buildImage(),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(onPressed: () async{
                final image = await controller.capture();

                saveAndShare(image);
                print(image);
              }, child: Text("Share"))
            ],
          )
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async{

    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);

  }

  Widget buildImage() => Image.network("http://payinpayonline.com/public_html/img/ads/ac2e7f038eeb5ed9b92d723255e3ff52.png",
    fit: BoxFit.cover,
  );

}
