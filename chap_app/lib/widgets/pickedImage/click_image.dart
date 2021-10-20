import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ClickImage extends StatefulWidget {
  ClickImage(this.getImage);

  void Function(File _image) getImage;

  @override
  _ClickImageState createState() => _ClickImageState();
}

class _ClickImageState extends State<ClickImage> {
  File? _pickedImage;
  void _takeImage() async {
    final _xImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 100,
        maxWidth: 100);
    if (_xImage != null) {
      print(_xImage.path);
      setState(() {
        _pickedImage = File(_xImage.path);
      });
      widget.getImage(_pickedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 40,
              backgroundImage:
                  _pickedImage != null ? FileImage(_pickedImage!) : null,
            ),
            if (_pickedImage == null)
              Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40,
                    )),
              ),
          ],
        ),
        FlatButton.icon(
            onPressed: _takeImage,
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.image),
            label: Text(
              'Take Image',
            ))
      ],
    );
  }
}
