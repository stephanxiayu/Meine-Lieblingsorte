import 'package:flutter/material.dart';
import 'package:meine_lieblingsorte/provider/great_places.dart';
import 'package:meine_lieblingsorte/sreens/map_screen.dart';


import 'package:provider/provider.dart';



class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    // Retreives the ID from the route
    final id = ModalRoute.of(context).settings.arguments;
    // Calls great_places findById method to return a single instance of a great place.
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(selectedPlace.location.address, style: TextStyle(fontSize: 15),))),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.file(
                selectedPlace.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
             SizedBox(height: 10),
            Text(selectedPlace.title, style: TextStyle(fontSize: 22, color: Colors.grey.shade900),),
            SizedBox(height: 10),
            Text("Deine Geschichte zum Bild:", style: TextStyle(color: Colors.grey),),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(selectedPlace.describtion, style: TextStyle(fontSize: 20, color: Colors.grey.shade900),),
            ),
           
         
            SizedBox(height: 10),
            FlatButton(
              child: Text('Standort auf der Karte'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => MapScreen(
                      initialLocation: selectedPlace.location,
                      isSelecting: false, //defualt so optional
                    ),
                  ),
                );
              },
            ), SizedBox(height: 30),
          ],
        ),
      ),
        
    );
  }
}
