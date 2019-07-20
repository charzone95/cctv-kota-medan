import 'package:cctv_medan/providers/CctvState.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Cctv.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ChangeNotifierProvider<CctvState>(
        builder: (BuildContext context) => CctvState(),
        child: MyHomePage(title: 'CCTV Kota Medan'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final cctvState = Provider.of<CctvState>(context);
    final listCctv = cctvState.listCctv;
    if (listCctv.isEmpty) {
      Future.delayed(Duration(milliseconds: 50), () {
        cctvState.fetchCctvData();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: cctvState.isLoadingCctv
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listCctv.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(listCctv[index].name),
                onTap: () {

                },
              ),
            ),
    );
  }
}
