import 'package:adsbw/models/tags.dart';
import 'package:adsbw/screens/location.dart';
import 'package:adsbw/widgets/customTile.dart';
import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_page/search_page.dart';

Algolia algolia = Algolia.init(
  applicationId: '2CBXJ2CO1C', //algolia application id
  apiKey:
      '9488a1b9e5008fcaa78539f8a6920340', //algolia api search key, dont use the admin key if youre only searching
);
AlgoliaQuery searchQuery;

class Search extends StatefulWidget {
  String searchText;
  String searchLabel;
  List<Tags> results;

  Search(
      {@required this.searchText,
      @required this.results,
      @required this.searchLabel});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;
  int groupValue;

  AlgoliaQuery query = algolia.instance.index('services');
  Future<String> location;
  String location2;

  @override
  void initState() {
    // TODO: implement initState
    //_search();
    location = getLocation();
    groupValue = 0;
    super.initState();
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10.0, 8.0, 50.0, 8.0),
        child: Text(
          widget.searchLabel,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.black, width: 0.5)),
      ),
    );
  }

  Widget row(Tags tag) {
    return ListTile(
      title: Text(
        tag.name,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      leading: Icon(
        Icons.search,
        size: 30.0,
      ),
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => new Search(
                      searchText: tag.name,
                      results: widget.results,
                      searchLabel: tag.name,
                    )));
      },
    );
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Search settings':
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new NewLocation(
                      value: groupValue,
                    ))).then((value) {
          setState(() {
            location2 = value[0];
            groupValue = value[1];
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20.0,
        title: InkWell(
          onTap: () => showSearch(
            context: context,
            delegate: SearchPage<Tags>(
              items: widget.results,
              searchLabel: "Search services...",
              failure: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No service found :(',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "The term you entered did not bring up any results.",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    Text(
                      "You may have mistyped your search term.",
                      style: TextStyle(fontSize: 14.0),
                    )
                  ],
                ),
              ),
              filter: (person) => [
                person.name,
              ],
              builder: (person) => row(person),
            ),
          ),
          child: _searchBar(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new NewLocation(
                            value: groupValue,
                          ))).then((value) {
                setState(() {
                  location2 = value[0];
                  groupValue = value[1];
                });
              });
            },
          ),
//          PopupMenuButton(
//              icon: Icon(Icons.more_vert),
//              color: Color(0xFF3EBACE),
//              onSelected: handleClick,
//              itemBuilder: (BuildContext context) {
//                return {'Search settings'}.map((String choice) {
//                  return PopupMenuItem<String>(
//                    value: choice,
//                    child: Text(choice),
//                  );
//                }).toList();
//              }),
        ],
      ),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          groupValue == 0
              ? FutureBuilder(
                  future: _searchQuery(),
                  builder: (BuildContext context,
                      AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Center(child: CircularProgressIndicator());
                        break;
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.data.hits.isEmpty) {
                          return new Center(
                            child:
                                Text("No results for '${widget.searchText}'."),
                          );
                        } else
                          return ListView.builder(
                            itemCount: snapshot.data.hits.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              AlgoliaObjectSnapshot snap =
                                  snapshot.data.hits[index];
                              return CustomCardTile(
                                name: snap.data["name"],
                                imageUrl: snap.data["imageUrl"],
                                location: snap.data["location"],
                                tags: snap.data["tags"],
                                number: snap.data["contactNumber"],
                                description: snap.data["description"],
                              );
                            },
                          );
                    }
                  },
                )
              : FutureBuilder(
                  future: _searchQuery2(location2),
                  builder: (BuildContext context,
                      AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Center(child: CircularProgressIndicator());
                        break;
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.data.hits.isEmpty) {
                          return new Center(
                            child:
                                Text("No results for '${widget.searchText}'."),
                          );
                        } else
                          return ListView.builder(
                            itemCount: snapshot.data.hits.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              AlgoliaObjectSnapshot snap =
                                  snapshot.data.hits[index];
                              return CustomCardTile(
                                name: snap.data["name"],
                                imageUrl: snap.data["imageUrl"],
                                location: snap.data["location"],
                                tags: snap.data["tags"],
                                number: snap.data["contactNumber"],
                                description: snap.data["description"],
                              );
                            },
                          );
                    }
                  },
                )
//          StreamBuilder(
//              stream: Connectivity().onConnectivityChanged,
//              builder: (BuildContext ctx,
//                  AsyncSnapshot<ConnectivityResult> snapShot) {
//                //var result = snapShot.data;
//                if (!snapShot.hasData ||
//                    snapShot.data == ConnectivityResult.none) {
//                  return Center(
//                      child: Text("Please check your internet connection"));
//                } else {
//                  _algoSearch();
//                  return _searching == true
//                      ? Center(child: CircularProgressIndicator())
//                      : _results.length == 0
//                          ? Center(
//                              child: Text(
//                                  "No results for '${widget.searchText}'."),
//                            )
//                          : ListView.builder(
//                              itemCount: _results.length,
//                              itemBuilder: (BuildContext ctx, int index) {
//                                AlgoliaObjectSnapshot snap = _results[index];
//                                return CustomCardTile(
//                                  name: snap.data["name"],
//                                  imageUrl: snap.data["imageUrl"],
//                                  location: snap.data["location"],
//                                  tags: snap.data["tags"],
//                                  number: snap.data["contactNumber"],
//                                );
//                              },
//                            );
//                }
//              }
//          _searching == true
//              ? Center(child: CircularProgressIndicator())
//              : _results.length == 0
//                  ? Center(
//                      child: Text("No results for '${widget.searchText}'."),
//                    )
//                  : ListView.builder(
//                      itemCount: _results.length,
//                      itemBuilder: (BuildContext ctx, int index) {
//                        AlgoliaObjectSnapshot snap = _results[index];
//                        return CustomCardTile(
//                          name: snap.data["name"],
//                          imageUrl: snap.data["imageUrl"],
//                          location: snap.data["location"],
//                          tags: snap.data["tags"],
//                          number: snap.data["contactNumber"],
//                          description: snap.data["description"],
//                        );
//                      },
//                    ),
//              ),
        ],
      )),
    );
  }

  Future<AlgoliaQuerySnapshot> _searchQuery() async {
    searchQuery = algolia.instance
        .index('services')
        .search(widget.searchText)
        .setAroundLatLng(
            await location) //set the radius of the location from the location of the phone
        .setAroundRadius(30000);
    return searchQuery.getObjects();
  }

  Future<AlgoliaQuerySnapshot> _searchQuery2(String loca) async {
    searchQuery = algolia.instance
        .index('services')
        .search(widget.searchText)
        .setAroundLatLng(
            loca) //set the radius of the location from the location of the phone
        .setAroundRadius(30000);
    return searchQuery.getObjects();
  }

  //get the lat and lgn coordinates of the devices current location
  Future<String> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return (position.latitude.toString() +
        ', ' +
        position.longitude.toString());
  }
}
