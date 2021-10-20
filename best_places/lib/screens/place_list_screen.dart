//packages
// import 'package:best_places/models/place.dart';
import 'package:best_places/providers/great_places.dart';
// import 'package:best_places/screens/place_detail_screen.dart';
import 'package:best_places/widgets/place_single_cart_item.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:carousel_slider/carousel_slider.dart';

//screens
import './add_place_screen.dart';

//providers
import '../providers/great_places.dart';

class PlaceListScreen extends StatefulWidget {
  @override
  _PlaceListScreenState createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  Future? _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces();
  }

  int _selectedIndex = 0;

  bool _showFavorites = false;

  void _tapIndex(int index, [bool favorites = false]) {
    print('index $index, Favourite $favorites');
    setState(() {
      _selectedIndex = index;
      _showFavorites = favorites;
    });
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Places"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlace.routeName);
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, snapShot) =>
              snapShot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<GreatPlaces>(
                      child: Center(
                        child: Text(!_showFavorites
                            ? 'No Place added yet!, Start adding some'
                            : 'No Favorites added Yet!'),
                      ),
                      builder: (ctx, greatPlaces, ch) => (_showFavorites
                                  ? greatPlaces.favItems.length
                                  : greatPlaces.items.length) <=
                              0
                          ? ch!
                          : PlaceSingleCartItem(_showFavorites
                              ? greatPlaces.favItems
                              : greatPlaces.items),
                    ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          //onTap: _tapIndex,
          backgroundColor: Colors.white,
          buttonBackgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).primaryColor,
          height: 50,
          items: [
            IconButton(
              onPressed: _selectedIndex == 0 ? null : () => _tapIndex(0),
              icon: Icon(
                Icons.home,
                color: Theme.of(context).accentColor,
              ),
            ),
            IconButton(
              onPressed: _selectedIndex == 1 ? null : () => _tapIndex(1, true),
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ));
  }
}
