import 'package:best_places/screens/google_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selectedPlace = Provider.of<GreatPlaces>(context, listen: false)
        .findById(id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: Hero(
                tag: selectedPlace.id,
                child: Image.file(
                  selectedPlace.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              selectedPlace.location.address!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => GoogleMapScreen(
                            initialLocation: selectedPlace.location,
                            isSelecting: false,
                          ),
                      fullscreenDialog: true),
                );
              },
              child: Text('View On Map'),
              textColor: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
