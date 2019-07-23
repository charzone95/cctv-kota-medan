import 'package:cctv_medan/player.dart';
import 'package:cctv_medan/providers/CctvState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/loading_indicator.dart';

class CctvListScreen extends StatelessWidget {
  CctvListScreen({Key key}) : super(key: key);

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
        title: Text('CCTV Kota Medan', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: cctvState.isErrorLoadCctv
              ? Text("Failed to load data")
              : cctvState.isLoadingCctv
                  ? Center(
                      child: CctvLoadingIndicator(),
                    )
                  : ListView.builder(
                      itemCount: listCctv.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(listCctv[index].name),
                        onTap: () {
                          var data = listCctv[index];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PlayerScreen(
                                title: data.name,
                                url: data.url,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
