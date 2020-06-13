import 'package:app/Club/club.dart';
import 'package:app/Club/club_dj.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

List songInfo;

class Place {
  final String id;
  final String pname;
  final String pstreet;
  final String img;

  Place(
    this.id,
    this.pname,
    this.pstreet,
    this.img,
  );
}

/*class Song {
  final String id;
  final String songname;
  final String songgenre;
  final String songartists;

  Song(
    this.id,
    this.songname,
    this.songgenre,
    this.songartists,
  );
}*/

class ClubPlace extends StatelessWidget {
  String userId;
  String userName = "";
  String rol = "";
  ClubPlace({Key key, this.userId, this.userName, this.rol}) : super(key: key);

  Future<List<Place>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    final response = await http.get('http://34.229.218.28:5002/api/v1/places');
    List data = jsonDecode(response.body);
    return List.generate(data.length, (int index) {
      return Place("${data[index]['id']}", "${data[index]['pname']}",
          "${data[index]['pstreet']}", "${data[index]['club_img']}");
    });
  }

   Future<List> songsData(id) async{
 final response =
      await http.get('http://34.229.218.28:5002/api/v1/places/' + id + '/songs');
 List data = jsonDecode(response.body);
 songInfo = data;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.only(
                left: 100.0, top: 50.0, bottom: 10.0, right: 100.0),
            width: MediaQuery.of(context).size.width,
            height: 120.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/images/logo.png"),
                    fit: BoxFit.fill))),
        Container(
            margin: const EdgeInsets.only(
                left: 10.0, top: 30.0, bottom: 20.0, right: 10.0),
            child: RichText(
              text: TextSpan(
                text: "Select the club to know more information",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 20),
              ),
            )),
        Expanded(
          child: SearchBar<Place>(
              onSearch: search,
              onItemFound: (Place place, int index) {
                return Card(
                  color: Color.fromRGBO(51, 54, 117, 0.3),
                  elevation: 3,
                  child: new InkWell(
                    onTap: () {
                      if (rol == "user") {
                        songsData(place.id).then((songInfo){    
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Club(  
                                    nameClub: place.pname,
                                   img: place.img,
                                    songname: songInfo[0]["songname"],
                                     street: place.pstreet,
                                     songartists: songInfo[0]["songartists"], 
                                    songgenre: songInfo[0]["songgenre"], 
                                    songnamelink: songInfo[0]["songnamelink"],)),
                        );
                        });
                      }
                      if (rol == "dj") {
                        songsData(place.id).then((songInfo){                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Club(
                                  nameClub: place.pname,
                                   img: place.img,
                                    songname: songInfo[0]["songname"],
                                     street: place.pstreet,
                                     songartists: songInfo[0]["songartists"], 
                                    songgenre: songInfo[0]["songgenre"], 
                                    songnamelink: songInfo[0]["songnamelink"],)),
                        );                       
                        });
                    }
                     songInfo = [];
                    },
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Stack(children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, top: 0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[name(place, index)],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          image(context, place, index)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[song(place, index)],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                );
            }
              ),
        )
      ],
    )));
  }

  Widget name(post, index) {
    return Container(
        padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
        child: RichText(
          text: TextSpan(
            text: post.pname,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: 20),
            children: <TextSpan>[
              TextSpan(
                text: '\n' + post.pstreet,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ));
  }

  Widget image(BuildContext context, post, index) {
    return Container(
        margin: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        child: Image.network(post.img, fit: BoxFit.fill));
  }

  Widget song(post, index) {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
      child: RichText(
        text: TextSpan(
          text: "More info +",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 20),
        ),
      ),
    );
  }
}
