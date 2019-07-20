import 'package:cctv_medan/models/Cctv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CctvState with ChangeNotifier {
  final List<Cctv> _listCctv = List<Cctv>();

  bool _isLoadingCctv = false;

  CctvState();

  List<Cctv> get listCctv => _listCctv;

  bool get isLoadingCctv => _isLoadingCctv;

  void fetchCctvData() async {
    if (_isLoadingCctv) {
      return;
    }

    _isLoadingCctv = true;
    notifyListeners();

    Dio dio = new Dio();
    Response response = await dio.get("http://api.charzone95.web.id/cctv-medan/");

    final decodedData = Cctv.fromJsonList(response.data);
    _listCctv.clear();
    decodedData.forEach((v) {
      _listCctv.add(v);
    });

    _isLoadingCctv = false;
    notifyListeners();
  }
}