import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddPlant.dart';
import 'plantCodition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fasela',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlantList(),
    );
  }
}

class PlantList extends StatefulWidget {
  PlantList({super.key});

  @override
  _PlantListState createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plants List',
            style: TextStyle(color: Color.fromARGB(255, 12, 12, 12))),
        centerTitle: true,
        backgroundColor: Color(0xFFFDEAED),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                  child: MaterialButton(
                    minWidth: 10,
                    height: 10,
                    child: const Text(
                      '+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddPlant()),
                      );
                    },
                  ),
                )),
          ),
          StreamBuilder<QuerySnapshot>(
            ///
            stream: _fireStore
                .collection('Plants')
                .orderBy('created', descending: false)
                .snapshots(),

            ///flutter aysnc snapshot
            builder: (context, snapshot) {
              List<MessageBubble> todoWidgets = [];
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              final plants = snapshot.data!.docs;

              for (var plants in plants) {
                final name = (plants.data() as dynamic)['name'];

                final age = (plants.data() as dynamic)['age'];

                final type = (plants.data() as dynamic)['type'];

                final description = (plants.data() as dynamic)['description'];

                final messageWidget = MessageBubble(
                    name: name, age: age, type: type, description: description);

                todoWidgets.add(messageWidget);
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(children: todoWidgets),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.name,
      required this.age,
      required this.type,
      required this.description});
  final String name;
  final int age;
  final String type;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 26),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Color(0xFFF1F4FF),
              ),
              child: MaterialButton(
                  onPressed: () async {
                    if (name.toLowerCase() == "tomato")
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlantCondition()),
                      );
                  },
                  child: Column(children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("age: ", style: TextStyle(fontSize: 18)),
                        Text(age.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Type: ", style: TextStyle(fontSize: 18)),
                        Text(type,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text("Description: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(description),
                        ),
                      ],
                    )
                  ]))),
        ],
      ),
    );
  }
}
