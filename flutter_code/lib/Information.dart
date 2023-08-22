import 'dart:io';

import 'package:birds_flask/Wiki.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wikidart/wikidart.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:birds_flask/sounds.dart';

class InfoPage extends StatefulWidget {
  const InfoPage(
      {Key? key, required this.prediction_result, required this.image, required this.wiki_info})
      :super(key: key);
  final XFile image;
  final String prediction_result;
  final String wiki_info;
  @override
  InfoPageState createState() => InfoPageState();
}
class InfoPageState extends State<InfoPage>
{

  AudioPlayer audioPlayer = new AudioPlayer();
  bool isPlaying=false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final BirdSound bsound = new BirdSound();



  @override
  void initState()
  {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPositon) {
      setState(() {
        position = newPositon;
      });
    });
  }

  @override
  void dispose()
  {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width;
    return new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/nature2.jpg"),
            fit: BoxFit.cover,
            // opacity: 0.3,
          )
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            widget.prediction_result.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          new Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
            child:Image.file(File(widget.image!.path),
              fit: BoxFit.fill,
            ),
          ),
          new SizedBox(
            height: 30,
          ),

          new Expanded(
            flex: 1,
            // child: new SingleChildScrollView(
            child:Center(
              child:ListView(
                // scrollDirection: Axis.vertical,//.horizontal
                // child:Column(
                shrinkWrap: true,
                children: <Widget>[
                  new Text(
                    widget.wiki_info,
                    style: new TextStyle(
                      fontSize: 16.0, color: Colors.white,
                      decoration: TextDecoration.none,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  new TextButton(onPressed:() async{
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:( context)=> WikipediaExplorer(name:widget.prediction_result.toString().toLowerCase())));},

                    child: Text('https://en.wikipedia.org/wiki/'+widget.prediction_result.toString().toLowerCase(),style: TextStyle(color: Colors.white,
                      fontSize: 18.0,)),),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),

          Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.only(left: 40, right: 40),
            child: TextButton(
              onPressed: () async{
                if(isPlaying)
                {
                  await audioPlayer.pause();
                }
                else
                {
                  // String url = 'https://www.bird-sounds.net/'+widget.name1;
                  // await audioPlayer.play(UrlSource(url));
                  await audioPlayer.resume();
                }
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )
                  )
              ),
              child: isPlaying?Text(
                  "PUASE",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)):Text(
                "PLAY",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),

          ),
        ],

      ),
    );
  }
  Future setAudio() async
  {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    String? url = bsound.sound(widget.prediction_result);
    print(url);
    audioPlayer.setSourceUrl(url!);
  }
}