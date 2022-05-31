import 'dart:convert';

import 'package:dateexample/features/model/fake_response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DateExampleViewModel extends ChangeNotifier {
  
  final String _baseUrl = "https://jsonplaceholder.typicode.com/posts";

  List<FakeDataModel> _fakeDataList = [];

  List<FakeDataModel> get fakeDataList => _fakeDataList;

  set fakeDataList(List<FakeDataModel> fakeDataList) {
    _fakeDataList = fakeDataList;
    notifyListeners();
  }

  String? _startDate;
  String? get startDate => _startDate;

  set startDate(String? startDate) {
    _startDate = startDate;
    notifyListeners();
  }
    String? _endDate;

  String? get endDate => _endDate;

  set endDate(String? endDate) {
    _endDate = endDate;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<void> fethData(String? startDate, String? endDate) async {
    _changeLoading();
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      fakeDataList = body
        .map(
          (dynamic item) => FakeDataModel.fromJson(item),
        )
        .toList();

    } else {
      throw "Error data not found";
    }
    _changeLoading();
    notifyListeners();
  }

  void _changeLoading() {
    isLoading = !isLoading;
  }


}
