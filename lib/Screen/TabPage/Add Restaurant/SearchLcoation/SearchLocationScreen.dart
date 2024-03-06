import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:near_me/Screen/TabPage/Add%20Restaurant/AddPage.dart';
import '../LocationService.dart';
import 'components/location_list_tile.dart';
import 'components/network_utility.dart';
import 'constants.dart';
import 'models/autocomplate_prediction.dart';
import 'models/place_auto_complate_response.dart';

class SearchLocationScreen extends StatefulWidget {
  final DatabaseReference ref;
  const SearchLocationScreen({Key? key, required this.ref}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<AutocompletePrediction> placePredictions = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https('maps.googleapis.com', 'maps/api/place/autocomplete/json', {"input": query, "key": apiKey});
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  final Stream<QuerySnapshot> _ristorantiStream = FirebaseFirestore.instance.collection('ristoranti').snapshots();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;

    final background = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Color.fromRGBO(239, 238, 243, 1);
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;
    final textColor2 = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white54 : Colors.black38;
    final buttonColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color.fromARGB(255, 33, 33, 33) : Colors.white;
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      controller: _searchController,
                      style: TextStyle(color: textColor),
                      onChanged: (value) {
                        placeAutocomplete(value);
                      },
                    ),
                  ),
                  CupertinoButton(
                    child: Text("Annulla"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) => LocationListTile(
                          location: placePredictions[index].description!,
                          press: () async {
                            setState(() {
                              _searchController.text = placePredictions[index].description!;
                              //_searchController.clear();
                              placePredictions.clear();
                            });
                            Map<String, dynamic> place = await LocationService().getPlace(_searchController.text);
                            List<String> placePhotosRef = [];
                            List<String> placePhotosUrl = [];
                            if (place['photos'] != null) {
                              for (int i = 0; i < 3; i++) {
                                placePhotosRef.add(place['photos'][i]['photo_reference']);
                              }
                              //print(placePhotosRef);
                              final String key = 'AIzaSyDYrKQHOuhXTev6wY1TWn9D7hmceuwsQQA';

                              for (int i = 0; i < 3; i++) {
                                placePhotosUrl.add(
                                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${placePhotosRef[i]}&key=$key');
                              }
                            }
                            //print(place);

                            //print(placePhotosUrl);
                            /* print('${place['geometry']['location']['lat']}');
                            print('${place['geometry']['location']['lng']}');
                            print('${place['icon']}');
                            print('${place['name']}');
                            print('${place['website']}');
                            print('${place['international_phone_number']}');*/

                            /* if (placePhotosUrl.isEmpty) {
                              await widget.ref.child('${place['name']}').update({
                                'lat': place['geometry']['location']['lat'],
                                'lng': place['geometry']['location']['lng'],
                                'image': place['icon'],
                                'name': place['name'],
                                'website': place['website'],
                                'phone': place['international_phone_number'],
                                'indirizzo': place['formatted_address']
                              });
                            } else {
                              await widget.ref.child('${place['name']}').update({
                                'lat': place['geometry']['location']['lat'],
                                'lng': place['geometry']['location']['lng'],
                                'image': place['icon'],
                                'name': place['name'],
                                'website': place['website'],
                                'photos': placePhotosUrl,
                                'phone': place['international_phone_number'],
                                'indirizzo': place['formatted_address']
                              });
                            }*/

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPage(
                                        image: '${place['icon']}',
                                        indirizzo: '${place['formatted_address']}',
                                        lat: '${place['geometry']['location']['lat']}',
                                        lng: '${place['geometry']['location']['lng']}',
                                        name: '${place['name']}',
                                        phone: '${place['international_phone_number']}',
                                        photos: placePhotosUrl.isEmpty ? [] : placePhotosUrl,
                                        website: '${place['website']}',
                                        ref: widget.ref,
                                        weekDay: place['opening_hours'] != null ? place['opening_hours']['weekday_text'] : [],
                                      ),
                                  fullscreenDialog: true),
                            );

                            /*FirebaseFirestore.instance.collection('ristoranti').add({
                              'lat': place['geometry']['location']['lat'],
                              'lng': place['geometry']['location']['lng'],
                              'image': place['icon'],
                              'nameOfPlace': place['name'],
                              'website': place['website'],
                              'photos': FieldValue.arrayUnion(placePhotosUrl),
                              'phone': place['international_phone_number'],
                              'indirizzo': place['formatted_address']
                            });*/
                          }))),
              /*StreamBuilder<QuerySnapshot>(
                stream: _ristorantiStream,
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
            
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SizedBox(
                      child: LinearProgressIndicator(),
                      height: 5,
                    ));
                  }
            
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          //leading: Icon(Icons.fork_left),
                          leading: SizedBox(
                            child: Image.network(data['image']),
                            width: size.width * .02,
                          ),
                          title: Text(data['nameOfPlace']),
                          subtitle: Text('${data['lat']},${data['lng']}'),
                        );
                      }).toList(),
                    ),
                  );
                },
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _getPlaceData(Map<String, dynamic> place) async {
  final double lat = place['geometry']['location']['lat'];
  final double lng = place['geometry']['location']['lng'];

  print('$lat,$lng');
}
