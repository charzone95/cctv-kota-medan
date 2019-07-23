import 'package:cctv_medan/player.dart';
import 'package:cctv_medan/providers/CctvState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/loading_indicator.dart';
import 'models/Cctv.dart';

class CctvListScreen extends StatefulWidget {
  CctvListScreen({Key key}) : super(key: key);

  @override
  _CctvListScreenState createState() => _CctvListScreenState();
}

class _CctvListScreenState extends State<CctvListScreen> {
  final _searchController = new TextEditingController();

  List<Cctv> displayedList;

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    void _filterList(String newText) {
      final cctvState = Provider.of<CctvState>(context);

      if (newText.isEmpty) {
        displayedList = cctvState.listCctv;
      } else {
        displayedList = cctvState.listCctv.where((val) {
          return val.name.toLowerCase().contains(newText.toLowerCase());
        }).toList();
      }
      setState(() {});
    }

    final cctvState = Provider.of<CctvState>(context);
    if (displayedList == null) {
      displayedList = cctvState.listCctv;
    }
    if (displayedList.isEmpty &&
        !cctvState.isLoadingCctv &&
        !cctvState.isErrorLoadCctv) {
      print("begin to fetch");
      Future.delayed(Duration(milliseconds: 50), () {
        cctvState.fetchCctvData();
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("CCTV Kota Medan"),
                content: Text(
                    "Aplikasi ini dibangun agar masyarakat yang memiliki waktu luang (seperti saya) dapat memantau arus lalu lintas di seputaran Kota Medan.\n\nLive streaming yang terdapat di aplikasi ini sepenunhnya merupakan milik ATCS Kota Medan.\n\n\n- Built with <3 with Flutter\nCharlie"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Oke sip!"),
                  ),
                ],
              ),
            );
          },
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Cari CCTV",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: _filterList,
              )
            : Text('CCTV Kota Medan', style: TextStyle(color: Colors.white)),
        centerTitle: _isSearching ? false : true,
        actions: <Widget>[
          _isSearching
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.text = "";
                      _filterList("");
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  }),
        ],
      ),
      body: Container(
        child: Center(
          child: cctvState.isErrorLoadCctv
              ? Text("Gagal memuat data")
              : cctvState.isLoadingCctv
                  ? Center(
                      child: CctvLoadingIndicator(),
                    )
                  : ListView.builder(
                      itemCount: displayedList.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(displayedList[index].name),
                        onTap: () {
                          var data = displayedList[index];
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
