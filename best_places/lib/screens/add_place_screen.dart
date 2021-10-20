//dart and flutter packages
import 'package:best_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

//providers
import '../providers/great_places.dart';

//widgets
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlace extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final TextEditingController _titlecontroller = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedlocation;

  void _selectPlace(double lat, double long) {
    _pickedlocation = PlaceLocation(latitude: lat, longitude: long);
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_titlecontroller.text.isEmpty ||
        _pickedImage == null ||
        _pickedlocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addplace(_titlecontroller.text, _pickedImage!, _pickedlocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Form
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titlecontroller,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),

          //Button to submit form
          RaisedButton.icon(
            onPressed: _savePlace,
            icon: Icon(Icons.add),
            label: Text("Add Place"),
            color: Theme.of(context).accentColor,

            //to remove drop shadow of button
            //to check what is drop shadow give elevation value > 0  and also comment materialTapTargetSize or instead of shrinkWrap use padded
            elevation: 0,

            // to remove space around button
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // default is padded
          )
        ],
      ),
    );
  }
}
