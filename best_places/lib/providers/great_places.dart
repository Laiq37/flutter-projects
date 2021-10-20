import 'package:best_places/helpers/db_helper.dart';
import 'package:best_places/helpers/location_helper.dart';
import 'package:flutter/cupertino.dart';
//import 'package:location/location.dart';
import 'dart:io';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  List<Place> get favItems {
    final List<Place> _favItems =
        _items.where((item) => item.isFavorite == Favorite.True).toList();
    return [..._favItems];
  }

  Future<void> addplace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedlocation,
  ) async {
    final String address = await LocationHelper.getPlaceAddress(
        pickedlocation.latitude, pickedlocation.longitude);
    final PlaceLocation updatedlocation = PlaceLocation(
        latitude: pickedlocation.latitude,
        longitude: pickedlocation.longitude,
        address: address);
    final Place newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: updatedlocation,
        image: pickedImage);
    _items.add(newPlace);
    notifyListeners();
    //we are accessing dbhelper insert methode which requires two thing one is tablename, and other is map which holds the value,
    DBhelpers.insert("user_places", {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_Latitude': newPlace.location.latitude,
      'loc_Longitude': newPlace.location.longitude,
      'loc_Address': newPlace.location.address,
      'is_Favorite': newPlace.isFavorite.index,
    });
    print('data is added');
  }

  Future<void> fetchAndSetPlaces() async {
    // print('in fetchAndSetPlaces');
    final dataList = await DBhelpers.getData('user_places');
    // print(dataList);
    _items = dataList
        .map(
          (item) => Place(
              id: item['id'],
              title: item['title'],
              image: File(item['image']),
              location: PlaceLocation(
                latitude: item['loc_Latitude'],
                longitude: item['loc_Longitude'],
                address: item['loc_Address'],
              ),
              isFavorite: Favorite.values[item['is_Favorite']]),
        )
        .toList();
    // print(_items[0]);
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> updateFavorite(String id, Favorite fav) async {
    // print('in GreatPlaces updateFavorite');
    await DBhelpers.updateFav('user_places', id, fav.index);
    _items.firstWhere((item) => item.id == id).isFavorite = fav;
    notifyListeners();
  }

  Future<void> deletePlace(
    String id,
  ) async {
    await DBhelpers.deleteData('user_places', id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
