import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:meine_lieblingsorte/helper/db_helper.dart';
import 'package:meine_lieblingsorte/provider/great_places.dart';
import 'package:meine_lieblingsorte/sreens/place_detail_screen.dart';

import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import './add_place_screen.dart';

class PlacesListScreen extends StatefulWidget {
  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 9,
        title: Center(
          child: Text(
            'Meine Lieblingsorte',
          ),
        ),
        actions: <Widget>[],
      ),
      body: FutureBuilder(
        // Calls setPLaces from great_places.dart with a futurebuilder and checks if it's waiting to show a progress indicator, otherwise render the Consumer data
        future: Provider.of<GreatPlaces>(context, listen: false).setPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            // childText will be displayed and not updated, referring to what was set as child: in the consumer. So in this case, the Centered text saying 'no places...' will be shown if the ternary of checking greatplaces being empty is trye
            : Consumer<GreatPlaces>(
                child: Center(
                  child: Lottie.network(
                      "https://assets10.lottiefiles.com/packages/lf20_ob2l65uz.json"),
                ),
                builder: (ctx, greatPlaces, childText) => greatPlaces
                            .items.length <=
                        0
                    ? childText
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, index) => Card(
                          elevation: 9,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    FileImage(greatPlaces.items[index].image),
                              ),
                              title: Text(greatPlaces.items[index].title),
                              subtitle: Text(
                                greatPlaces.items[index].location.address,
                                style: TextStyle(fontSize: 10),
                              ),
                              onTap: () {
                                // The arguments here is how we pass data to the detail screen and how we also fulfill the 'id' variable in place_detail_screen which takes from ModalRoute...settings.arguments
                                Navigator.of(context).pushNamed(
                                    PlaceDetailScreen.routeName,
                                    arguments: greatPlaces.items[index].id);
                              },
                              trailing: IconButton(
                                  color: Colors.grey.shade200,
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () async {
                                   
                                    await showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: const <Widget>[
                                                  Text(
                                                      'Deine Liebingsorte ...'),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(''),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Teilen'),
                                                onPressed: () async {
                                                  await Share.shareFiles([
                                                    greatPlaces
                                                        .items[index].image.path
                                                  ],
                                                      text: greatPlaces
                                                          .items[index]
                                                          .describtion);
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Löschen'),
                                                onPressed: () async {
                                               
                                                  await setState(() {
                                                    DBHelper.deletePlaces(
                                                        greatPlaces
                                                            .items[index].id);
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  })),
                        ),
                      ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 9,
        onPressed: () async {
         

          await Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
        },
        label: const Text(
          'Add',
          style: TextStyle(color: Colors.grey),
        ),
        icon: const Icon(
          Icons.thumb_up,
          color: Colors.grey,
        ),
        backgroundColor: Colors.white,
      ),
     
    );
  }
}

