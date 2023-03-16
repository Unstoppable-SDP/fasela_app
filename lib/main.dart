import 'package:fasela_app/ForGroundLocalNotification.dart';
import 'package:fasela_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'plantsList.dart';
import 'plantCodition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'DiseaseDetection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // firebase
  final _fireStore = FirebaseFirestore.instance;

  //TODO: add script to ask the user to add a new package -if needed-

  // form variables
  late String name;
  late String type;
  late String description;
  late int age;
  late TextEditingController nameTextController;
  late TextEditingController typeTextController;
  late TextEditingController descriptionTextController;
  late TextEditingController ageTextController;

  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.instance.getInitialMessage();
  }

  @override
  void initState() {
    super.initState();
    nameTextController = TextEditingController();
    typeTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    ageTextController = TextEditingController();
    setupInteractedMessage();
  }

  getToken() async {
    // _realtime
    //     .child('fcm-token/${await getFcmToken()}')
    //     .set({"token": await getFcmToken()});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    nameTextController.dispose();
    typeTextController.dispose();
    descriptionTextController.dispose();
    ageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalNotification.initialize();
    // For Forground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(37.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 26),
            child: Text(
              'Add New Plant',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                color: Colors.black,
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Plant Name",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )),
          TextField(
            controller: nameTextController,
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(
              hintText: 'Name',
              alignLabelWithHint: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Type",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )),
          TextField(
            controller: typeTextController,
            onChanged: (value) {
              type = value;
            },
            decoration: const InputDecoration(
              hintText: 'Type',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Age (in week)",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )),
          TextField(
            controller: ageTextController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              age = int.parse(value);
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: 'Age',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Description",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )),
          TextField(
            controller: descriptionTextController,
            onChanged: (value) {
              description = value;
            },
            maxLines: 5,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              hintText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: Material(
              color: Color(0xFFFDEAED),
              borderRadius: BorderRadius.circular(20.0),
              child: MaterialButton(
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'Create Plant',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  _fireStore.collection('Plants').add({
                    'name': name,
                    'type': type,
                    'description': description,
                    'age': age,
                    'created': Timestamp.now(),
                  });
                  nameTextController.clear();
                  typeTextController.clear();
                  descriptionTextController.clear();
                  ageTextController.clear();
                },
              ),
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Material(
                      color: Color.fromARGB(255, 216, 223, 246),
                      borderRadius: BorderRadius.circular(20.0),
                      child: MaterialButton(
                        minWidth: 150,
                        height: 42.0,
                        child: const Text(
                          'Plant list',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlantList()),
                          );
                        },
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Material(
                      color: Color.fromARGB(255, 216, 223, 246),
                      borderRadius: BorderRadius.circular(20.0),
                      child: MaterialButton(
                        minWidth: 150,
                        height: 42.0,
                        child: const Text(
                          'Plant condition',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlantCondition()),
                          );
                        },
                      ),
                    ),
                  )),
            ],
          ),

          Row (children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Material(
                      color: Color.fromARGB(255, 216, 223, 246),
                      borderRadius: BorderRadius.circular(20.0),
                      child: MaterialButton(
                        minWidth: 150,
                        height: 42.0,
                        child: const Text(
                          'Disease Detection',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiseaseDetection()),
                          );
                        },
                      ),
                    ),
                  )),
            ],)
        ],
      ),
    )));
  }
}
