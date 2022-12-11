import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late var _response;
  bool isLoading = false;
  String? _groupValue;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    var result = await http.get(Uri.parse(
        "https://quiz-app.code-studio4.com/exam/give_exam?examId=200060&userId=1"));
    _response = jsonDecode(result.body);
    print(_response['data']['question']);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text("QUIZE"),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _response['data']['question'].length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            _response['data']['question'][i]['options'].length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            title: Text(_response['data']['question'][i]
                                ['question_details']),
                            value: index.toString() + i.toString(),
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value.toString() as String;
                              });
                            },
                          );
                        }),
                  );
                }),
      ),
    );
  }
}
