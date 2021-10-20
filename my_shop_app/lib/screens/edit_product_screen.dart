import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //we have to dispose focusNode b/c focusNode will not dispose after the screen removes, so our app may have memory leaks
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();

  // to acess form data we have to initilize gloabalkey of type formState
  //and in the form widget we have to set this global var in key arg
  //we use gloabal key when we want to interact with widget in the code
  final _form = GlobalKey<FormState>();

  var _isInit = true;

  bool _isloading = false;

  //var of type product
  var _editingproduct =
      Product(id: "", title: "", description: "", price: 0, imageUrl: "");

  var _initValues = {
    'title': "",
    "description": '',
    'price': '',
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute.of(context)?.settings.arguments as String;
        //if (productId != null) {
        _editingproduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editingproduct.title,
          "description": _editingproduct.description,
          'price': _editingproduct.price.toString(),
        };
        _imageUrlController.text = _editingproduct.imageUrl;
        //}
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  // void _saveForm() {
  //   //if we want to validate the field in form we have to use validate() method and also use validator in every textfield where we need to validate
  //   final _validate = _form.currentState!.validate();
  //   if (!_validate) {
  //     return;
  //   }
  //   _form.currentState!.save();
  //   setState(() {
  //     _isloading = true;
  //   });
  //   if (ModalRoute.of(context)?.settings.arguments != null) {
  //     Provider.of<Products>(context, listen: false)
  //         .updateProduct(_editingproduct.id, _editingproduct);
  //     setState(() {
  //       _isloading = false;
  //     });
  //     Navigator.of(context).pop();
  //   } else {
  //     Provider.of<Products>(context, listen: false)
  //         .addProduct(_editingproduct)
  //         .catchError((error) {
  //       //Show Dialog return a future so we have to return ShowDialog
  //       return showDialog<Null>(
  //           context: context,
  //           builder: (ctx) => AlertDialog(
  //                 title: Text("An Error Occured"),
  //                 content: Text("Something Went Wrong!"),
  //                 actions: [
  //                   FlatButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Text("okay!"))
  //                 ],
  //               ));
  //     }).then((_) {
  //       setState(() {
  //         _isloading = false;
  //       });
  //       Navigator.of(context).pop();
  //     });
  //   }
  //   // Navigator.of(context).pop();
  // }

  Future<void> _saveForm() async {
    final _validate = _form.currentState!.validate();
    if (!_validate) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isloading = true;
    });
    if (ModalRoute.of(context)?.settings.arguments != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editingproduct.id, _editingproduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editingproduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An Error Occured"),
                  content: Text("Something Went Wrong!"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("okay!"))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isloading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      // Form is a built-in widget in flutter, which grouped all the user input, we dont have to write logic for grouping of input data
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      //TextFormField is connected to form widget
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                            labelText: "Title",
                            labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (val) {
                          _editingproduct = Product(
                            id: _editingproduct.id,
                            title: val!,
                            description: _editingproduct.description,
                            price: _editingproduct.price,
                            imageUrl: _editingproduct.imageUrl,
                            isfavourite: _editingproduct.isfavourite,
                          );
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Title is required!";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (val) {
                          _editingproduct = Product(
                            id: _editingproduct.id,
                            title: _editingproduct.title,
                            description: _editingproduct.description,
                            price: double.parse(val!),
                            imageUrl: _editingproduct.imageUrl,
                            isfavourite: _editingproduct.isfavourite,
                          );
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Price is required!";
                          }
                          if (double.tryParse(val) == null) {
                            return "Please Enter a valid number.";
                          }
                          if (double.parse(val) <= 0) {
                            return "Price must be greater than 0";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (val) {
                          _editingproduct = Product(
                              id: _editingproduct.id,
                              title: _editingproduct.title,
                              description: val!,
                              price: _editingproduct.price,
                              imageUrl: _editingproduct.imageUrl,
                              isfavourite: _editingproduct.isfavourite);
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Description is required!";
                          }
                          if (val.length < 10) {
                            return "Description must be atleast of 10 character";
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter Url of image")
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //initialvalue and controller cant be used simultaneously so we have just used controller
                              //initialValue: ,

                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onSaved: (val) {
                                _editingproduct = Product(
                                  id: _editingproduct.id,
                                  title: _editingproduct.title,
                                  description: _editingproduct.description,
                                  price: _editingproduct.price,
                                  imageUrl: val!,
                                  isfavourite: _editingproduct.isfavourite,
                                );
                              },
                              //calling saveform method in onfieldSubmitted arg
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "ImageUrl is required!";
                                }
                                if (!val.startsWith("http")) {
                                  return "Enter a valid url which start from http";
                                }
                                if (!val.endsWith('.png') &&
                                    !val.endsWith(".jpeg") &&
                                    !val.endsWith("jpg")) {
                                  return "Enter a valid image url which ends at .png/.jpeg/.jpg";
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
