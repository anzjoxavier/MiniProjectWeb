// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:html';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

import 'package:projectapp/ResultPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sarcasm and Toxicity Analyser',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  stt.SpeechToText speech = stt.SpeechToText();
  Color iconColor = Colors.white;
  // bool _isSpeechStarted = false;
  bool _isListening = false;

  // bool _isEndOfSpeech = false;

  @override
  void initState() {
    // TODO: implement initState
    speech = stt.SpeechToText();
    super.initState();
  }

  void onListen() async {
    if (!_isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
          iconColor = Colors.red;
        });
        speech.listen(
          listenMode: stt.ListenMode.search,
          onResult: (val) => setState(() {
            print(val.recognizedWords);
            _textEditingController.text = val.recognizedWords;
          }),
        );
      } else {
        setState(() {
          _isListening = false;
          iconColor = Colors.white;
          speech.stop();
        });
      }
    }
  }

  void stopListening() {
    setState(() {
      _isListening = false;
      iconColor = Colors.white;
      speech.stop();
    });
  }

  String dropdownvalue = 'Sarcasm Detection';
  var items = ["Sarcasm Detection", "Toxicity Detection"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.redAccent,
              Colors.blueAccent,
              Colors.redAccent,
              //add more colors
            ]),
          ),
        ),
        // backgroundColor:Color.fromARGB(255, 251, 0, 125).withOpacity(0.8),
        title: const Center(
            child: Text(
          "Sarcasm and Toxicity Detector",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        )),
      ),
      body: Stack(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            "assets/background.png",
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 250,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Colors.redAccent,
                        Colors.blueAccent,
                        Colors.purpleAccent
                        //add more colors
                      ]),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.57), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: const Color.fromARGB(255, 251, 0, 125)
                          .withOpacity(0.75),
                      isExpanded: true,
                      value: dropdownvalue,
                      underline: Container(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Center(
                              child: Text(
                            items,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          )),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                width: 0.60 * MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: iconColor,
                      ),
                      onPressed: () {
                        if (_isListening == false) {
                          onListen();
                        } else {
                          stopListening();
                        }
                      },
                    ),
                    suffixIconColor: Colors.amber,
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Type your Comment",
                    hintStyle: TextStyle(color: Colors.grey[350]),
                    fillColor: Colors.grey[50]!.withOpacity(0.50),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_textEditingController.text.isNotEmpty) {
                    if (_isListening == true) {
                      stopListening();
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ServerPage(
                              sentance: _textEditingController.text,
                              dropdownvalue: dropdownvalue),
                        ));
                  } else {
                    final snackBar = SnackBar(
                      content: const Text('Text is Empty'),
                      backgroundColor: (Colors.black12),
                      action: SnackBarAction(
                        label: 'dismiss',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 0.05 * MediaQuery.of(context).size.width,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(NetworkImage("assets/tree.png")),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Find',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
