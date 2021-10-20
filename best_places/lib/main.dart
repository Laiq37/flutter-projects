//flutter packages
import 'package:best_places/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//models

//providers
import './providers/great_places.dart';

//screens
import './screens/place_list_screen.dart';
import './screens/add_place_screen.dart';

//widgets

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => GreatPlaces(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlaceListScreen(),
        routes: {
          AddPlace.routeName: (ctx) => AddPlace(),
          PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
        },
        // ),
      ),
    );
  }
}
