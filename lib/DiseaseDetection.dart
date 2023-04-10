import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class DiseaseDetection extends StatefulWidget {
  @override
  _DiseaseDetectionState createState() => _DiseaseDetectionState();
}

class _DiseaseDetectionState extends State<DiseaseDetection> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  Future<File> resizeImage(File file, int width, int height) async {
    // Read the image file
    final bytes = await file.readAsBytes();

    // Decode the image using the image package
    final image = img.decodeImage(bytes);

    // Resize the image using the image package
    final resizedImage = img.copyResize(image!, width: width, height: height);

    // Create a new File object with the resized image data
    final resizedFile = await file.create();
    await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

    return resizedFile;
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    final image2 = await resizeImage(image, 224, 224);
    var decodedImage = await decodeImageFromList(image2.readAsBytesSync());
    print("width");
    print(decodedImage.width);
    print("height");
    print(decodedImage.height);

    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 11,
        threshold: 0.05);

    final dio = Dio();
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    late bool assign = false;

    dio.post("http://192.168.227.80:80/predict", data: data).then((response) {
      print("looo ***********");
      print(response.data["data"]["class"]);
      if (response.data["data"]["class"] != null) {
        assign = true;
        if (response.data["data"]["class"] == 'healthy') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HealthyPlant(image: _image)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DiseaseDetailScreen(
                    response.data["data"]["class"].toString(), _image)),
          );
        }
      }
    }).catchError((e) {
      print(e);
    });

    setState(() {
      _output = output!;
      _loading = false;
    });

    if (assign != true) {
      if (_output[0]["label"] == 'healthy') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthyPlant(image: _image)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DiseaseDetailScreen(_output[0]["label"].toString(), _image)),
        );
      }
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
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
              backgroundColor: Color(0xFFF1F4FF),
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
                color: Color(0xFFF1F4FF),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 189, 122, 132),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 200,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 17),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 216, 223, 246),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'Take A Photo',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: pickGalleryImage,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 200,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 17),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 216, 223, 246),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  'Pick from gallery',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}

class DiseaseDetailScreen extends StatefulWidget {
  final String disease;
  final File image;
  const DiseaseDetailScreen(this.disease, this.image);

  @override
  _DiseaseDetailScreenState createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F4FF),
        centerTitle: true,
        title: const Text(
          'Disease Detection',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        child: Container(
          child: Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        widget.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Disease Type',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        ///
                        stream:
                            _fireStore.collection('Plant Diseases').snapshots(),

                        ///flutter aysnc snapshot
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                            );
                          }
                          final plants = snapshot.data!.docs;
                          late var disease;

                          for (var plant in plants) {
                            if (plant.id == widget.disease) {
                              disease = plant;
                            }
                          }
                          final Name = (disease.data() as dynamic)['Name'];

                          final Cause = (disease.data() as dynamic)['Cause'];

                          final Symptoms =
                              (disease.data() as dynamic)['Symptoms'];

                          final Treatment =
                              (disease.data() as dynamic)['Treatment'];

                          return Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(children: [
                                Text(
                                  Name,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(123, 200, 186, 1),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      color: Color(0xFFF1F4FF),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            Symptoms,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Case:',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      color: Color(0xFFFBF2E6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            Cause,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Cure for Disease',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      color: Color(0xFFFDEAED),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            Treatment,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                              ]));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}

class HealthyPlant extends StatelessWidget {
  const HealthyPlant({super.key, required this.image});
  final File image;
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F4FF),
        centerTitle: true,
        title: const Text(
          'Disease Detection',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
        child: Container(
          child: Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 75),
                  Column(
                    children: [
                      const Text(
                        "Congratulations !",
                        style: TextStyle(
                          color: Color.fromRGBO(123, 200, 186, 1),
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text(
                          "you have a perfectly healthy tomato garden!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
