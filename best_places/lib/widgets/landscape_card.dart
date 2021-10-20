import 'package:flutter/material.dart';

import '../models/place.dart';

class LandScapeCard extends StatelessWidget {
  final List<Place> items;
  final Function navigateToDetailScreen, deleteThePlace, updatePlaceFavStatus;

  LandScapeCard(this.items, this.navigateToDetailScreen, this.deleteThePlace,
      this.updatePlaceFavStatus);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: FileImage(items[index].image),
            ),
            title: Text(items[index].title),
            subtitle: Text(items[index].location.address!),
            onTap: () => navigateToDetailScreen(items[index].id),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(items[index].isFavorite == Favorite.True
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => updatePlaceFavStatus(
                      items[index].id, items[index].isFavorite),
                ),
                IconButton(
                  color: Theme.of(context).errorColor,
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteThePlace(items[index].id),
                ),
              ],
            )),
      ),
      itemCount: items.length,
    );
  }
}
