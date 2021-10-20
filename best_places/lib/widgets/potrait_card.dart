import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/place.dart';

class PotraitCard extends StatelessWidget {
  final List<Place> items;
  final Function navigateToDetailScreen, deleteThePlace, updatePlaceFavStatus;

  PotraitCard(this.items, this.navigateToDetailScreen, this.deleteThePlace,
      this.updatePlaceFavStatus);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: (items).map((item) {
        //print('_showFavorite: $_showFavorites');
        return Builder(
          builder: (ctx) {
            return Dismissible(
              key: Key(item.id),
              direction: DismissDirection.up,
              background: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
                size: 100,
              ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Are you sure you wish to delete this item?"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () => deleteThePlace(item.id),
                            child: const Text("DELETE")),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("CANCEL"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.hardEdge,
                elevation: 6,
                shadowColor: Theme.of(context).primaryColorLight,
                margin: const EdgeInsets.only(top: 30, bottom: 40, right: 30),
                color: const Color.fromRGBO(255, 191, 0, 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => navigateToDetailScreen(item.id),
                        child: Hero(
                          tag: item.id,
                          child: Image.file(
                            item.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      //minVerticalPadding: 10,
                      trailing: IconButton(
                        icon: Icon(
                          item.isFavorite == Favorite.False
                              ? Icons.favorite_border
                              : Icons.favorite,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () =>
                            updatePlaceFavStatus(item.id, item.isFavorite),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.location.address!,
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        //height: 540,
        height: MediaQuery.of(context).size.height,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
      ),
    );
  }
}
