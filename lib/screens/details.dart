import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  String imageUrl;
  String location;
  String description;
  String number;
  List tags;
  String name;

  Details(
      {this.number,
      this.name,
      this.location,
      this.tags,
      this.imageUrl,
      this.description});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String getTags(List names) {
    String services = "";
    for (var i in names) {
      if (i == names[names.length - 1]) {
        services += "$i";
      } else {
        services += "$i, ";
      }
    }
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Ads Bw",
          style: TextStyle(
            shadows: [
              Shadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 4.0),
                  blurRadius: 6.0),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0),
                  ],
                ),
                child: Image(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 4.0),
                              blurRadius: 6.0),
                        ],
                        color: Colors.white,
                        fontSize: 32.0,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 20.0,
                        ),
                        Text(
                          widget.location,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 6.0),
                            ],
                            color: Colors.white70,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  child: Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.w600,
                    ),
                  ),
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                ),
                Container(
                  child: Text(
                    "Services:",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    getTags(widget.tags),
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.w600,
                    ),
                  ),
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Number: ${widget.number}",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
