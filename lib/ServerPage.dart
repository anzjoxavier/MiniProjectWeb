import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:projectapp/constants.dart';

class ServerPage extends StatelessWidget {
  final String sentance;
  final String dropdownvalue;
  const ServerPage({
    Key? key,
    required this.sentance,
    required this.dropdownvalue,
  }) : super(key: key);

  Future<String> getSarcastic() async {
    final response = await http.post(
      Uri.parse('$URL/sarcasm_predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'string': sentance,
      }),
    );

    return response.body;
  }

  Future<String> getToxic() async {
    final response = await http.post(
      Uri.parse('$URL/toxicity_predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'string': sentance,
      }),
    );

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          
          colors: [
              Colors.redAccent, 
              Colors.blueAccent,
               Colors.redAccent,
              //add more colors
            ]
          ),
      ),
    ),
        // backgroundColor:Color.fromARGB(255, 251, 0, 125).withOpacity(0.8),
        title:const Text(
          "Result",
          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700),
        ),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Given Comment: $sentance",style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              const SizedBox(height: 25,),
              FutureBuilder(
                builder: (ctx, snapshot) {
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
          
                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      const JsonDecoder decoder = JsonDecoder();
                      final Map<String, dynamic> object =
                          decoder.convert(snapshot.data!);
                      if (dropdownvalue == 'Sarcasm Detection') {
                        return Center(
                            child: SizedBox(
                          height: 0.60 * MediaQuery.of(context).size.height,
                          width: 0.60 * MediaQuery.of(context).size.width,
                          child: object['is_sarcastic'] == 1
                              ? Image.network("assets/Sarcasm.png")
                              : Image.network("assets/Not Sarcasm.png"),
                        ));
                      } else {
                        return Center(
                         
                          child: SizedBox(
                                      height:0.60 * MediaQuery.of(context).size.height,
                                      width: 0.60 * MediaQuery.of(context).size.width,
                                      child: object['toxic']['toxic'] ==1 ? Image.network("assets/toxic.png"): Image.network("assets/nontoxic.png"),
                        ));
                      }
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                future: dropdownvalue == 'Sarcasm Detection'
                    ? getSarcastic()
                    : getToxic(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
