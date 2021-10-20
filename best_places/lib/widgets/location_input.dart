import 'package:best_places/screens/google_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function _onSelectPlace;

  LocationInput(this._onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double long) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImageUrl(
        latitude: lat, longitutde: long);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      final locationCord = await Location().getLocation();
      // print("${locationCord.latitude}\n${locationCord.longitude}");
      _showPreview(locationCord.latitude!, locationCord.longitude!);
      widget._onSelectPlace(locationCord.latitude, locationCord.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _onSelectMap(BuildContext context) async {
    final LatLng? _selectedLocation =
        await Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true, //optional, gives different look
            builder: (ctx) => GoogleMapScreen(
                  isSelecting: true,
                )));
    if (_selectedLocation == null) {
      return;
    }
    _showPreview(_selectedLocation.latitude, _selectedLocation.longitude);
    widget._onSelectPlace(
        _selectedLocation.latitude, _selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  "No location chosen",
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getUserCurrentLocation,
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: () => _onSelectMap(context),
              icon: Icon(
                Icons.map,
              ),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
            )
          ],
        )
      ],
    );
  }
}
