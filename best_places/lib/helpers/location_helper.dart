import 'package:http/http.dart' as http;
import 'dart:convert';

const Google_Api_key = 'Enter Your Google Api key';

class LocationHelper {
  static String generateLocationPreviewImageUrl(
      {double? latitude, double? longitutde}) {
    print(latitude);
    print(longitutde);
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitutde&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitutde&key=$Google_Api_key';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$Google_Api_key'); //this is the reverse geocoding Api which coverts coordinated of lat long into address
    //geocoding api is used to convert lat long cord to address and address to lat long coord

    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
