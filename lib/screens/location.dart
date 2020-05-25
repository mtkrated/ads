import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyAkt5Q0mgCTGSZfm2fZiAhJQXV64zQTw8c";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class NewLocation extends StatefulWidget {
  int value;
  NewLocation({this.value});
  @override
  _NewLocationState createState() => _NewLocationState();
}

class _NewLocationState extends State<NewLocation> {
  int _groupValue;
  bool _isLocation;
  String coordinates;
  Mode _mode = Mode.overlay;
  TextEditingController locationController = TextEditingController();
  String location = "Search a location";
  List info = ["location", 5];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLocation = false;
    _groupValue = widget.value;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "en",
      components: [Component(Component.country, "bw")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      coordinates = "$lat, $lng";
      setState(() {
        locationController.text = p.description;
      });

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description}")),
      );
    }
  }

  Widget _getLocation() {
    return InkWell(
      onTap: () {
        _handlePressButton();
      },
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: TextFormField(
            readOnly: true,
            maxLines: null,
            autofocus: !_isLocation,
            controller: locationController,
            decoration: InputDecoration(
              hintText: location,
              prefixIcon: Icon(Icons.location_on),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Required!';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text("Location"),
        leading: new IconButton(
          icon: new Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              info[0] = coordinates;
              Navigator.pop(context, info);
            },
            child: Text(
              "Apply",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Content(
            title: "Location",
            child: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Near you'),
                    leading: Radio(
                      activeColor: Color(0xFF3EBACE),
                      focusColor: Color(0xFF3EBACE),
                      value: 0,
                      groupValue: _groupValue,
                      onChanged: (newValue) {
                        setState(() {
                          _groupValue = newValue;
                          info[1] = newValue;
                          _isLocation = false;
                        });
                      },
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    thickness: 2.0,
                  ),
                  ListTile(
                    title: const Text('Select Location'),
                    leading: Radio(
                      activeColor: Color(0xFF3EBACE),
                      focusColor: Color(0xFF3EBACE),
                      value: 1,
                      groupValue: _groupValue,
                      onChanged: (newValue) {
                        setState(() {
                          _groupValue = newValue;
                          info[1] = newValue;
                          _isLocation = true;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: _isLocation == true,
                    child: _getLocation(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  final String title;
  final Widget child;

  Content({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      margin: EdgeInsets.all(10.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            color: Colors.blueGrey[50],
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 22.0,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
