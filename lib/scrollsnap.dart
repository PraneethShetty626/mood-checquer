import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class Scroll extends StatefulWidget {
  const Scroll({Key? key}) : super(key: key);

  @override
  _ScrollState createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  //////////////Data for displaying
  var li = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var emoji = ["😊", "😥", "😪", "😭"];
  ////////////////
  ///
  ///Counter for reference
  var findex = 0;

  ///
  ///

  bool isLoading = true;

  // //////////Retrieving data from firebase realtime database using http package
  List<String> list = [];

  Future<void> readData() async {
    var url = "https://moodchecquer-default-rtdb.firebaseio.com/" + "Data.json";
    // Do not remove “data.json”,keep it as it is
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((element) {
        list.add(element);
      });
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      throw error;
    }
  }

//////////////////
  ///
  ///
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  ///
  ///
  Text ponk(String mood) {
    return Text(
      mood,
      style: const TextStyle(color: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ??Displaying Emoji based on the count

          // /
          findex == 0
              ? ponk(emoji[0])
              : findex <= 4
                  ? ponk(emoji[1])
                  : findex <= 8
                      ? ponk(emoji[2])
                      : ponk(emoji[3]),

          // Displaying the current index of focus
          Text(
            findex.toString(),
            style: const TextStyle(fontSize: 30),
          ),
          // Customized slider
          // implemented by scrollsnap package
          Container(
            height: 120,
            width: 250,
            child: ScrollSnapList(
              itemBuilder: (ctx, index) {
                return SizedBox(
                  height: 100,
                  width: 50,
                  child: Column(
                    children: [
                      findex != index
                          ? Text(li[index].toString())
                          : const SizedBox(),
                      SizedBox(
                        height: findex != index ? 70 : 100,
                        child: const VerticalDivider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: li.length,
              itemSize: 50,
              scrollDirection: Axis.horizontal,
              onItemFocus: (ind) {
                setState(() {
                  findex = ind;
                });
              },
            ),
          ),
          // Printing the mood based on the count
          isLoading
              ? Text("None")
              : findex == 0
                  ? ponk(list[0])
                  : findex <= 4
                      ? ponk(list[1])
                      : findex <= 8
                          ? ponk(list[2])
                          : ponk(list[3]),
          // Submission button for Audio
          InkWell(
              child: Container(
                width: 190,
                height: 40,
                margin: EdgeInsets.only(top: 80),
                alignment: Alignment.center,
                child: Text("Submit"),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              onTap: () async {
                String sentence = findex == 0
                    ? list[0]
                    : findex <= 4
                        ? list[1]
                        : findex <= 8
                            ? list[2]
                            : list[3];
                var result = await FlutterTts().speak(sentence);
              }),
        ],
      ),
    );
  }
}
