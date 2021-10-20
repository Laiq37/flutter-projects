//packages
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//models
import '../models/place.dart';

class GoogleMapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  GoogleMapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: 24.9709433, longitude: 67.0602567),
      this.isSelecting = false});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_pickedLocation);
                      },
                icon: Icon(Icons.done))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude),
            zoom: 16),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: MarkerId('m1'),
                    position: _pickedLocation ??
                        LatLng(widget.initialLocation.latitude,
                            widget.initialLocation.longitude))
              },
      ),
    );
  }
}
