import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projectapp/Widgets/HistoryCard.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // ignore: non_constant_identifier_names
  late final Box HistoryBox;

  @override
  void initState() {
    HistoryBox = Hive.box('HistoryBox');
    super.initState();
  }

  void deleteAtHistory(int index) {
    HistoryBox.deleteAt(index);
    int len = HistoryBox.get("length");
    HistoryBox.put("length", len - 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int historyLength = HistoryBox.get("length");
    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
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
        title: const Row(
          children: [
            Icon(
              Icons.history,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "History",
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
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
                  height: 20,
                ),
                //Heading Column
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        width: 0.86 * MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent[400],
                            borderRadius: BorderRadius.circular(25)),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width:
                                      0.64 * MediaQuery.of(context).size.width,
                                  child: const Text(
                                    "Comment ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              const Text("Option",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        )),
                    const SizedBox(
                      width: 87,
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 126,
                  child: ListView.builder(
                      itemCount: historyLength,
                      itemBuilder: (context, index) {
                        int newIndex = historyLength - index - 1;
                        List<String> wordList = HistoryBox.getAt(newIndex).split("^");
                        return HistoryCard(
                          comment: wordList[1],
                          dropdownvalue: wordList[0],
                          onPressed: () {
                            deleteAtHistory(newIndex);
                          },
                        );
                      }),
                )

                // HistoryCard(comment: "Hello How are you Hello",dropdownvalue: "Sarcasm Detection",onPressed: (){},)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
