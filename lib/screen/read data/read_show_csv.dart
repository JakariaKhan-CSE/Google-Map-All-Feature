import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadAndShowCSVFile extends StatefulWidget {
  const ReadAndShowCSVFile({super.key});

  @override
  State<ReadAndShowCSVFile> createState() => _ReadAndShowCSVFileState();
}

class _ReadAndShowCSVFileState extends State<ReadAndShowCSVFile> {
  List<List<dynamic>> csvData = [];

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final csvString = await rootBundle.loadString('assets/test.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);
    setState(() {
      csvData = rowsAsListOfValues;
      print(csvData);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CSV File'),centerTitle: true,),
      body: ListView.builder(
        itemCount: csvData.length-1,
        itemBuilder: (context, index) {
          final row = csvData[index+1];
        return ListTile(
        leading: CircleAvatar(
          child: Text((index+1).toString()),
        ),
          title: Text(row[10]),
          subtitle: Text(row[11]),
        );
      },),
    );
  }
}
