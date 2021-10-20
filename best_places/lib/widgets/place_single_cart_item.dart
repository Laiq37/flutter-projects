import 'package:best_places/widgets/landscape_card.dart';
import 'package:best_places/widgets/potrait_card.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:best_places/screens/place_detail_screen.dart';

import 'package:best_places/models/place.dart';

import 'package:best_places/providers/great_places.dart';

class PlaceSingleCartItem extends StatelessWidget {
  //final bool _showFavorites;
  //final GreatPlaces greatPlaces;
  final List<Place> items;

  PlaceSingleCartItem(
    this.items,
  ); //(this._showFavorites, this.greatPlaces);

  @override
  Widget build(BuildContext context) {
    void _navigateToDetailScreen(String itemId) {
      Navigator.of(context)
          .pushNamed(PlaceDetailScreen.routeName, arguments: itemId);
    }

    void _deleteThePlace(String itemId) {
      Navigator.of(context).pop();
      Provider.of<GreatPlaces>(context, listen: false).deletePlace(itemId);
    }

    void _updatePlaceFavStatus(String itemId, Favorite itemFav) {
      Provider.of<GreatPlaces>(context, listen: false).updateFavorite(
          itemId, itemFav == Favorite.False ? Favorite.True : Favorite.False);
    }

    Future<void> _deleteConfirmAlert(String itemId) async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Provider.of<GreatPlaces>(context, listen: false)
                        .deletePlace(itemId);
                  },
                  child: const Text("DELETE"),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          });
    }

    return Container(
        width: double.infinity,
        child: OrientationBuilder(builder: (ctx, orientation) {
          // List<Place> items =
          //     _showFavorites ? greatPlaces.favItems : greatPlaces.items;
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            switchInCurve: Curves.slowMiddle,
            switchOutCurve: Curves.fastOutSlowIn,
            child: orientation == Orientation.landscape
                ? LandScapeCard(items, _navigateToDetailScreen,
                    _deleteConfirmAlert, _updatePlaceFavStatus)
                : PotraitCard(items, _navigateToDetailScreen, _deleteThePlace,
                    _updatePlaceFavStatus),
          );
        }));
  }
}
