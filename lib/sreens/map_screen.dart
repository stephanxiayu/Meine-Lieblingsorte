import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:location/location.dart';
import 'package:meine_lieblingsorte/helper/place.dart'; // Comes from pubspec.yml google_maps_flutter dependency. ALlows GoogleMap()


class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation; // Instantiated in place.dart as a type
  final bool isSelecting;
  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await Location().getLocation();
    
    } catch (error) {
      return;
    }
  }
  // Initializes it, both values are defaulted
  MapScreen({
    this.initialLocation = 
        const PlaceLocation(latitude: 52.531677, longitude: 13.381777),
    this.isSelecting = false,
  });

  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
 
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              // If there is no picked location, onPressed is set to null so the button is disabled, otherwise is enabled and will navigate back with _pickedLocation
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      // We pop the screen and pass the picked location to the location_input.dart Future _selectOnMap()
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 12,
        ),
        // Allows ontap actions, calls above method to set LatLgn location
        onTap: widget.isSelecting ? _selectLocation : null,
        // If we have a picked location due to ontop, render a marker (this is a Set data type, which is like a list with only values {}, each value needs to be unique in a set) for it otherwise null/
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  // If picked location is null, which it is when coming from place_detail_screen, then show initialLocation, otherwise show pickedLocation which is when we came from add_place_screen
                  position: _pickedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                ),
              },
      ),
       
    );
  }
}
