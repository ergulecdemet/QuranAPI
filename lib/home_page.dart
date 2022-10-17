import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

import 'model/quran_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url = Uri.parse('http://api.alquran.cloud/v1/surah');
  int? counter;
  var quranResult;
  Future callData() async {
    try {
      final response = await http.get(url); //istek atılan kısım
      if (response.statusCode == 200) {
        var result = quranFromJson(response.body); //json yapisi donuyor

        if (mounted) {
          setState(() {
            counter = result.data.length;
            quranResult = result;
          });
        }
        return result;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kuran-ı Kerim Sure Listesi"),
        backgroundColor: Colors.green,
      ),
      body: Center(
          child: counter != null
              ? ListView.builder(
                  itemCount: counter,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(quranResult.data[index].name +
                          ' (' +
                          quranResult.data[index].englishName +
                          ')'),
                      subtitle: Text("Meaning of English : " +
                          quranResult.data[index].englishNameTranslation),
                      leading: Text(
                        quranResult.data[index].number.toString(),
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                    );
                  })
              : Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: (() {
          callData();
        }),
        backgroundColor: Colors.green,
      ),
    );
  }
}
