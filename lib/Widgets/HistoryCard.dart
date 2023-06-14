import 'package:flutter/material.dart';

import '../ResultPage.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard(
      {super.key,
      required this.comment,
      required this.dropdownvalue,
      required this.onPressed});
  final String comment;
  final VoidCallback onPressed;
  final String dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ResultPage(
                          sentance: comment, dropdownvalue: dropdownvalue),
                    ));
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: 0.86 * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[50]!.withOpacity(0.50),
                      borderRadius: BorderRadius.circular(25)),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 0.64 * MediaQuery.of(context).size.width,
                            child: Text(
                              comment,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            )),
                        Text(dropdownvalue,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18))
                      ],
                    ),
                  )),
            ),
            RawMaterialButton(
              onPressed: onPressed,
              elevation: 2.0,
              fillColor: Colors.grey[50]!.withOpacity(0.50),
              padding: const EdgeInsets.all(11.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.close,
                size: 26.0,
                color: Colors.white,
              ),
            )
          ],
        ),
      ],
    );
  }
}
