import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class DiseaseDetection extends StatefulWidget {
  @override
  _DiseaseDetectionState createState() => _DiseaseDetectionState();
}

class _DiseaseDetectionState extends State<DiseaseDetection> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override 
  void initState() {
    super.initState();
    loadModel().then((value){
      setState(() {});
    });
  }

  @override 
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 11,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/lables.txt',
    );
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      if (image != null) {
       _image = File(image.path);
      }
    });

    loader();

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      if (image != null) {
       _image = File(image.path);
      }
    });

    loader();

    classifyImage(_image);
  }

  loader() {
    // here any widget would do
    return AlertDialog(
        title: Text('Wait.. Loading data..'),
    );
}

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 223, 246),
        centerTitle: true,
        title: Text(
          'Disease Detection',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 216, 223, 246),
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: _loading == true 
                  ? null
                  : Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              _image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        _output != null
                          ? Text(
                            'The toamto condition is ${_output[0]['label']}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                          : Container(),
                          Divider(
                            height: 25,
                            thickness: 1,
                          ),
                      ],
                    ),
                    ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 200,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                        decoration: BoxDecoration(color: Color.fromARGB(255, 216, 223, 246), borderRadius: BorderRadius.circular(15),),
                        child: Text(
                          'Take A Photo',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: pickGalleryImage,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 200,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 216, 223, 246),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text(
                          'Pick from gallery',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    )
    );
  }
}
