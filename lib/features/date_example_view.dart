import 'package:dateexample/product/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateExample extends StatelessWidget {
  DateExample({Key? key}) : super(key: key);
  final DateExampleViewModel _viewModel = DateExampleViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      builder: (context, child) {
        return _buildScaffold();
      },
    );
  }

  Scaffold _buildScaffold() {
    return Scaffold(
        appBar: AppBar(),
        body: _buildConsumer(),
      );
  }

  Consumer<DateExampleViewModel> _buildConsumer() {
    return Consumer<DateExampleViewModel>(
            builder: (context, dateProvider, child) {
          return _columnWidgetBuilder(context, dateProvider);
        });
  }

  Column _columnWidgetBuilder(BuildContext context, DateExampleViewModel dateProvider) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textButtonBuilderStartDate(context, dateProvider),
              _textButtonBuilderEndDate(context, dateProvider),
              Center(
                child: _viewModel.isLoading != true
                    ? _buttonWidgetBuilder()
                    : _circularWidgetBuilder(),
              ),
              _listViewWidgetBuilder(context, dateProvider),
            ],
          );
  }

  TextButton _textButtonBuilderStartDate(BuildContext context, DateExampleViewModel dateProvider) {
    return TextButton(
                  onPressed: () {
                    showAlertDialog(context,true);
                  },
                  child: Text(
                      "Başlangıç Tarihi Seç : ${dateProvider.startDate ?? 'DateTime Seçilmedi'}"));
  }

  TextButton _textButtonBuilderEndDate(BuildContext context, DateExampleViewModel dateProvider) {
    return TextButton(
                  onPressed: () {
                    showAlertDialog(context,false);
                  },
                  child: Text(
                      "Bitiş Tarihi Seç : ${dateProvider.endDate ?? 'DateTime Seçilmedi'}"));
  }

  SizedBox _listViewWidgetBuilder(BuildContext context, DateExampleViewModel dateProvider) {
    return SizedBox(
                height: MediaQuery.of(context).size.height/2,
                child: ListView.builder(
                  itemCount: dateProvider.fakeDataList.length,
                  itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                      title: Text(dateProvider.fakeDataList[index].title ?? ""),
                      subtitle: Text(dateProvider.fakeDataList[index].body ?? ""),
                      leading: Text(dateProvider.fakeDataList[index].id.toString()),
                    ),
                  );
                }),
              );
  }

  ElevatedButton _buttonWidgetBuilder() {
    return ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text("Verileri Getir"));
  }

  ElevatedButton _circularWidgetBuilder() {
    return const ElevatedButton(
                        onPressed: null, child: CircularProgressIndicator());
  }

  void _fetchData() async {
                  if (_viewModel.startDate != null &&
                      _viewModel.endDate != null) {
                    await _viewModel.fethData(
                        _viewModel.startDate, _viewModel.endDate);
                  }
                }

  showAlertDialog(BuildContext context, bool dateType) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("${dateType != false ? 'Başlangıç' : 'Bitiş'} Tarihi Seç"),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: SfDateRangePicker(
          onSelectionChanged: (value) {
            if (dateType != false) {
              _viewModel.startDate = value.value.toString();
              Navigator.pop(context);
            } else {
              _viewModel.endDate = value.value.toString();
              Navigator.pop(context);
            }
            
          },
          view: DateRangePickerView.month,
          monthViewSettings:
              const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
