import 'dart:io';

enum Favorite { False, True }

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address;

  const PlaceLocation(
      {required this.latitude, required this.longitude, this.address});
}

class Place {
  String id;
  String title;

  //Location will have vaue longitude and lattidue b/c google map take long and lat offset on which basis it determines the place location where it is located on map and also we store address of place in it
  //for this we are creating a class
  final PlaceLocation location;

  // as we are going to store image in device so the type of image is not string its a type of File which we can use by importing dart.io module
  final File image;

  Favorite isFavorite;

  Place({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
    this.isFavorite = Favorite.False,
  });
}
