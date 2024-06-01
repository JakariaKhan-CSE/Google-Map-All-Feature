import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
class GooglePlaceApiScreen extends StatefulWidget {
  const GooglePlaceApiScreen({super.key});

  @override
  State<GooglePlaceApiScreen> createState() => _GooglePlaceApiScreenState();
}

class _GooglePlaceApiScreenState extends State<GooglePlaceApiScreen> {
  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String seassion_token = "123456";
  List<dynamic> placesList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("uuid: ${uuid}");
    _controller.addListener(
      onChange
    );
  }

  void onChange(){
    // print('onChange called');
if(seassion_token == null)
  {
    setState(() {
      seassion_token = uuid.v4();
      print("Seassion token: ${seassion_token}");
    });
  }
getSuggestion(_controller.text);
  }

  void getSuggestion(String input)async{
    print("getSuggestion   Seassion token: ${seassion_token}");

    //final String kPLACES_API_KEY = 'AIzaSyBJ_XlxltqRMHEaqUxKak6LkIb0jt4qRWM';
   // final String kPLACES_API_KEY = 'AIzaSyCfXnfJAD4JnbM5JjF8zRD4HxW_0cc1MLU';
    //final String kPLACES_API_KEY = 'AIzaSyBh7-oxF3fKK-Xq4ABUzx6UCC33WrfmeXs';  //original api
    final String kPLACES_API_KEY = 'AIzaSyBTDqAhurKsynehyIXmC35IO272b3xdvX4';  //my api
    String baseURL   = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$seassion_token';

    var response = await http.get(Uri.parse(request));
print(response.body.toString());
    if(response.statusCode == 200)
      {
setState(() {
  placesList = jsonDecode(response.body.toString()) ['predictions'];
});
      }
    else{
      throw Exception('Failed to load data. Response not 200');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Search Place API',style: TextStyle(color: Colors.white),),centerTitle: true,backgroundColor: Colors.indigoAccent,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search places with name'
            ),
          ),
            Expanded(child: ListView.builder(
              itemCount: placesList.length,
              itemBuilder: (context, index) {
return GestureDetector(
    onTap: ()async{
      List<Location> locations = await locationFromAddress(placesList[index]['description']);

      print(locations.last.latitude);
      print(locations.last.longitude);
    },
    child: ListTile(title: Text(placesList[index]['description']),));
            },))

          ],
        ),
      ),
    );
  }
}
