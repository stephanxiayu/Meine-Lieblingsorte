import 'package:flutter/material.dart';
import 'package:meine_lieblingsorte/provider/great_places.dart';
import 'package:meine_lieblingsorte/sreens/add_place_screen.dart';
import 'package:meine_lieblingsorte/sreens/place_detail_screen.dart';
import 'package:meine_lieblingsorte/sreens/places_list_screen.dart';

import 'package:provider/provider.dart';


void main() {
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
       ChangeNotifierProvider.value(
        value: GreatPlaces(),),
      
        
        ],
        child: MaterialApp(debugShowCheckedModeBanner: false,
          title: 'Meine Lieblingsorte',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.grey.shade700,
          ),
          home: PlacesListScreen(),
          routes: {
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
            PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
          },
        ),
      
    );
  }
}
