import 'package:adsbw/models/tags.dart';
import 'package:adsbw/screens/search.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Tags> _result = new List<Tags>();
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Tags>> key = new GlobalKey();
  TextEditingController searchController = new TextEditingController();
  bool loading = true;

  int tag = 1;
  List<String> tags = [];
  List<String> tagNames = [];

  List<String> options = ['News', 'Entertainment', 'Automotive'];

  @override
  void initState() {
    _getTags();
    super.initState();
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
                builder: (context) => Search(
                      searchText: tag.name,
                      results: _result,
                      searchLabel: tag.name,
                    )));
      },
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
      child: Container(
        padding: EdgeInsets.fromLTRB(15.0, 12.0, 15.0, 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Search services...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            Icon(
              Icons.search,
              size: 25.0,
              color: Colors.grey,
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.grey, width: 0.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              InkWell(
                onTap: () => showSearch(
                  context: context,
                  delegate: SearchPage<Tags>(
                    items: _result,
                    searchLabel: 'Search services...',
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
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 30.0, top: 10.0),
                child: Text(
                  "What would you like to find?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
              ),
              Content(
                title: "Popular",
                child: ChipsChoice<int>.single(
                  value: tag,
                  options: ChipsChoiceOption.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                  onChanged: (val) => setState(() => tag = val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getTags() async {
    final List<Tags> data = new List<Tags>();
    await Firestore.instance
        .collection("tags")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((f) => {
              data.add(Tags(
                name: f.data["name"],
              )),
            }));
    _result = data;
    setState(() {
      loading = false;
    });
  }

  List<String> _getTagsList(List<Tags> tag) {
    final List<String> _name = [];
    for (var i in tag) {
      _name.add(i.name);
    }
    return _name;
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
            width: double.infinity,
            padding: EdgeInsets.all(15),
            color: Colors.blueGrey[50],
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.w500),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
