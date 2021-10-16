import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meine_lieblingsorte/helper/place.dart';
import 'package:meine_lieblingsorte/image_input.dart';
import 'package:meine_lieblingsorte/location_input.dart';
import 'package:meine_lieblingsorte/provider/great_places.dart';


import 'package:provider/provider.dart';


class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _describtionController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;
 

  // For getting image from image_input to submit in form
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  // Save form data
  void _savePlace() {
    // Quick validation
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null||_describtionController.text.isEmpty) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace( _titleController.text,_describtionController.text, _pickedImage,  _pickedLocation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Deine Lieblingsorte in deinem Leben", style: TextStyle(fontSize: 15),)),
      ),
      body: Column(
        // Stretches the children across the screen to take full width horizontally.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Takes all the available space
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                   
                    // Since no parent Form() we use TextField() instead of TextFormField(), and have to manually wire it up
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                     TextField(maxLines: 3,
                       controller: _describtionController,cursorColor: Colors.grey.shade900,
                    decoration: InputDecoration(labelText: "Deine Geschichte"),style: TextStyle(color: Colors.grey.shade900),
                  ),
                    SizedBox(height: 10),
                    ImageInput(_selectImage),
                    SizedBox(height: 10),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          Container(height: 60,
            child: RaisedButton.icon(
              // Removes drop shadow
              elevation: 9,
              // Modifies the space around an element for tapping on it. ShrinkWrap decreases this margin size
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Colors.grey.shade900,
              icon: Icon(Icons.add, color: Colors.white,),
              label: Text('Add Place', style: TextStyle(color: Colors.white),),
              onPressed: _savePlace,
            ),
          ),
        ],
      ),
       
    );
  }
}
