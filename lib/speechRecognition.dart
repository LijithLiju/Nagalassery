import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

///to change change language call this.. currently set in en_IN in [startListening()]
/*if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }*/

class VoiceCommander extends StatefulWidget {
  final Function(String commands) commands;

  const VoiceCommander({Key key, @required this.commands}) : super(key: key);

  @override
  _VoiceCommanderState createState() => _VoiceCommanderState();
}

class _VoiceCommanderState extends State<VoiceCommander> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50;
  double maxSoundLevel = -50;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  final SpeechToText speech = SpeechToText();
  List<HelpList> helpTexts = List();

  @override
  void initState() {
    helpTexts = helpList();

    if (!_hasSpeech) initSpeechState();
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onError: errorListener, onStatus: statusListener);

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
      if (hasSpeech) startListening();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Text(
            lastError.isNotEmpty ? lastError : lastWords,
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          bottom: 20.0,
          left: 20.0,
          right: 20.0,
//				  alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView("Try saying"),
              SizedBox(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: helpTexts.length,
                  itemBuilder: (context, index) {
                    return helpTexts[index];
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(top: 20.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .26, spreadRadius: level * 1.5, color: Colors.black.withOpacity(.05))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: !_hasSpeech ? null : speech.isListening ? stopListening : startListening,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void startListening() {
    lastWords = "How can i help you?";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: "en_IN",
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    /* - ${result.finalResult}*/
    setState(() {
      lastWords = "${result.recognizedWords}";
      print("lastWords $lastWords");
      widget.commands(lastWords);
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    //print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    /* - ${error.permanent}*/
    setState(() {
      lastError = "${error.errorMsg}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  List<HelpList> helpList() {
    return [
      HelpList(
          text: "Open Accounts",
          subText: "Opens your account",
          onPressed: () {
            widget.commands("open account");
          }),
      HelpList(
          text: "Get details",
          subText: "Opens passbook",
          onPressed: () {
            widget.commands("get details");
          }),
      HelpList(
          text: "QR scan",
          subText: "Opens scanner to scan QR code",
          onPressed: () {
            widget.commands("qr scan");
          }),
    ];
  }
}

class HelpList extends StatelessWidget {
  final String text, subText;
  final Function onPressed;

  const HelpList({Key key, this.text, this.onPressed, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175.0,
      margin: EdgeInsets.all(5.0),
      child: RaisedButton(
        onPressed: onPressed,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ListTile(
          title: TextView(text ?? ""),
          subtitle: TextView(
            subText ?? "",
            color: Colors.grey,
            size: 10.0,
          ),
        ),
      ),
    );
  }
}
