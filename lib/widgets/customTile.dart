import 'package:adsbw/screens/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomTile extends StatelessWidget {
  String imageUrl;
  String name;
  String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      color: const Color(0xFFEEEEEE),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 16.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(location),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  String name;
  String location;
  List tags;
  String description;
  String imageUrl;

  CustomCard(
      {this.location, this.name, this.imageUrl, this.description, this.tags});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: const Color(0xFFEEEEEE),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: new BorderRadius.circular(50.0),
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Container(
                  height: 100.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Flexible(
                        child: Text(
                          widget.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Flexible(
                        child: Text(
                          getTags(widget.tags),
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Flexible(child: Text(widget.location)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
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
}

class CustomCardTile extends StatefulWidget {
  String name;
  String location;
  List tags;
  String description;
  String imageUrl;
  String number;

  CustomCardTile(
      {this.location,
      this.name,
      this.imageUrl,
      this.number,
      this.tags,
      this.description});

  @override
  _CustomCardTileState createState() => _CustomCardTileState();
}

class _CustomCardTileState extends State<CustomCardTile> {
  Future<void> _launched;

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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color(0xFFF3F5F7),
      elevation: 1.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                            imageUrl: widget.imageUrl,
                            name: widget.name,
                            description: widget.description,
                            number: widget.number,
                            tags: widget.tags,
                            location: widget.location,
                          )));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
            ),
            title: Text(
              widget.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(getTags(widget.tags)),
                SizedBox(
                  height: 3.0,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(widget.location)
                  ],
                )
              ],
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 26.0,
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () => setState(() {
                  print(widget.number);
                  _launched = _launchCaller("tel:${widget.number}");
                }),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.call,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Call",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _launchCaller(String url) async {
    if (await canLaunch(url.trim())) {
      await launch(url.trim());
    } else {
      throw 'Could not launch $url';
    }
  }
}
