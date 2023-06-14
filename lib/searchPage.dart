// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';
import 'package:projectapp/history.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

import 'package:projectapp/ResultPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final Box HistoryBox;

  final TextEditingController _textEditingController = TextEditingController();

  stt.SpeechToText speech = stt.SpeechToText();
  Color iconColor = Colors.white;
  bool _isListening = false;

  @override
  void initState() {
    speech = stt.SpeechToText();
    HistoryBox = Hive.box('HistoryBox');
    initLength();
    super.initState();
  }

  void initLength() async {
    var len = HistoryBox.get("length");

    if (len == null) {
      HistoryBox.put("length", 0);
    }
  }

  // ignore: no_leading_underscores_for_local_identifiers
  addTOHistory(String _dropdownvalue, String _text) async {
    HistoryBox.add("$_dropdownvalue^$_text");
    int len = HistoryBox.get("length");
    HistoryBox.put("length", len + 1);
  }

  showHistory() {
    int len = HistoryBox.get("length");
    for (int i = 0; i < len; i++) {
      print(HistoryBox.getAt(i));
      // var hai = HistoryBox.get("Hello");
      // print(hai);
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          // Hive.box('HistoryBox').clear();
          showHistory();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const HistoryPage(),
              ));
        },
        icon: const Icon(Icons.history),
        label: const Text('History'),
      ),
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
                  style: TextStyle(color: Colors.pinkAccent), 
                  cursorColor: Colors.redAccent,
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
                    addTOHistory(dropdownvalue, _textEditingController.text);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ResultPage(
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
