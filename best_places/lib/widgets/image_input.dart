import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function _selectedImage;

  ImageInput(this._selectedImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takenPicture() async {
    final picker = ImagePicker();
    //to use image picker we have to first add ImagePicker dependcy in pubspec.yaml and also read readme file attach to dos
    //pickImage returns a future so we make our taken function a futur funct and use awiat with ImagePicker.platform.pickImage(source: source)
    final PickedFile? imageFile =
        await picker.getImage(source: ImageSource.camera, maxHeight: 600);

    if (imageFile != null) {
      final File fileImage = File(imageFile.path);
      setState(() {
        //getImage returned a pickedFile type, so to store it in _storedImage which is a File type var we have to convert imageFile into File using File(pickedFilevarname.path)
        _storedImage = fileImage;
      });
      //to store file in device storage first we have to make ap copy of image first we have to convert imageFile as File type then we have to use .copy method
      //in andriod and ios we cant write data anywhere in device but we can write data on device where both os allowed us
      // two use provided path by both os to store data on their device we have to use path_provider package and for constructing path we have to use path package
      //before copying the file to the path we have configure where we allowed to store our file in device for that we have to use
      final appDir = await syspath.getApplicationDocumentsDirectory();
      //to get image name which is automatically assigned by the device camera we have to use (path package)path.(basename method) basename.((imageFile)fileImage.path)
      final fileName = path.basename(fileImage.path);
      final savedImage =
          await File(imageFile.path).copy("${appDir.path}/$fileName");
      widget._selectedImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No Image Taken",
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          height: 10,
        ),
        //Expanded make sure that child should take the remaining space of row or column
        Expanded(
          child: FlatButton.icon(
            onPressed: _takenPicture,
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
