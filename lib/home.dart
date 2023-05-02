import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  TextEditingController message = TextEditingController();
  String ans = "";
  bool clicked = false;
  Widget build(BuildContext context) {
    showwidget() {
      if (clicked == true && ans == "") {
        return CircularProgressIndicator(
          color: Colors.white,
        );
      } else {
        return Padding(
            padding: EdgeInsets.all(15),
            child: AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
              TyperAnimatedText(
                textAlign: TextAlign.start,
                ans,
                textStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.08),
              )
            ]));
      }
    }

    final String apiUrl = 'https://chatgpt-api7.p.rapidapi.com/ask';

    final Map<String, String> headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': 'e47da9067fmsh5ff9ccd4c986c74p16e758jsncb64922ec1cc',
      'X-RapidAPI-Host': 'chatgpt-api7.p.rapidapi.com',
    };
    var response;
    Future askQuestion(String message) async {
      final String jsonData = '{"query":"${message}"}';
      response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonData,
      );
      if (response.statusCode == 200) {
        if (response.body != null) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            ans = jsonData['response'];
          });
          print(ans);
        } else {
          ans = "";
        }
      } else {
        throw Exception(
            'Failed to load data, status code: ${response.statusCode}');
      }
    }

    void initState() {
      // TODO: implement initState
      super.initState();
      clicked = false;
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              Icon(Icons.blur_on),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                "Aka AI",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              )
            ],
          )),
      body: SingleChildScrollView(
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.78,
                  child: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                        reverse: true,
                        child: clicked
                            ? showwidget()
                            : Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Ask me anything",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.08),
                                ))),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                        controller: message,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(width: 3, color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                    width: 3, color: Colors.white)))),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      clicked = true;
                      ans = "";
                      setState(() {
                        askQuestion(message.text);
                      });
                      message.clear();
                    },
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 49, 49, 49),
    );
  }
}
