import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:safeSoftware/Util/GlobalWidgets.dart';

class QRScanView extends StatefulWidget {
  @override
  _QRScanViewState createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 256,
              width: 256,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton.icon(
                onPressed: () => controller.toggleFlash(),
                icon: Icon(
                  Icons.flash_on,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                label: TextView(
                  "Flash",
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.first.then((scanData){
	    print("SCAN RESULT :: $scanData");
	    Navigator.of(context).pop(scanData);
    });
  
   /* controller.scannedDataStream.listen((scanData) async {


    });*/
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
