import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:birds_flask/Predict.dart';
import 'information.dart';
import 'dart:convert';
import 'package:wikidart/wikidart.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) :super(key: key);
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {

  late XFile image;
  File? path;
  String Result='';
  bool imageSelect=false;
  var ok;
  final pick = Predict();

  Future<dynamic> something(name) async {
    var res = await Wikidart.searchQuery(name);
    var pageid = res?.results?.first.pageId;

    if (pageid != null) {
      var google = await Wikidart.summary(pageid);
      setState(() {
        ok = google!.extract!;
      });
    }
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child:Opacity(
                opacity: 0.5 ,
                child: Image.asset('assets/images/grass_dew_drops_193835_800x1420.jpg',
                  fit: BoxFit.fitHeight,),

              ),
            ),
            Positioned(
              left: -40,
              top: 70,
              child: Container(
                width: 500,
                height: 275,
                // margin: EdgeInsets.all(10),
                child:Image.asset('assets/images/A-removebg-preview.png'),),),
            Positioned(
              left: 120,
              top: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text('Pick image from \ngallery or camera',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () async{
                      selectImageFromCamera();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                        )
                    ),
                    child: Text(
                      "Camera",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () async{
                      selectImageFromGallery();

                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )
                        )
                    ),
                    child: Text(
                      "Gallery",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      onPressed: () async{
                        String info = await something(Result);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => InfoPage(prediction_result: Result,image: image,wiki_info: info,)));
                      },

                      color: Colors.amber,
                      child: Text('Predict',
                        style: TextStyle(
                          color: Colors.white,
                        ),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery);
    if (file != null) {
      image = file;
      path = File(image!.path);
    }
    String name = await pick.predictImage(path!);
    print(name);
    setState(() {
      Result = name;
    });
  }

  Future selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera);
    if (file != null) {
      image=file;
      path = File(image!.path);
    }
    dynamic name = pick.predictImage(path!);
    print(name);
    setState(() {
      Result = name;
    });
  }
}