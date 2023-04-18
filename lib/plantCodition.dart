import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DiseaseDetection.dart';

class PlantCondition extends StatefulWidget {
  const PlantCondition({super.key});

  @override
  State<PlantCondition> createState() => _PlantConditionState();
}

class _PlantConditionState extends State<PlantCondition> {
  Query dbRef = FirebaseDatabase.instance.ref();
  Widget listItem({required Map conditions}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
        child: SingleChildScrollView(
            child: Column(
          children: [
            const Text(
              "Plant Condition",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 26),
                    height: 120,
                    width: 149,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Color(0xFFFBF2E6),
                    ),
                    child: Column(children: [
                      const Text(
                        "Humidity",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(conditions["airHumidity"],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          const Text("%",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600))
                        ],
                      )
                    ])),
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 26),
                    height: 120,
                    width: 149,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Color(0xFFFDEAED),
                    ),
                    child: Column(children: [
                      const Text(
                        "Temperature",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(conditions["airTemperature"],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          const Text("°C",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600))
                        ],
                      )
                    ])),
              ],
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 26),
                    height: 120,
                    width: 149,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Color(0xFFF1F4FF),
                    ),
                    child: Column(children: [
                      const Text(
                        "Soil Moisture",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              int.parse(conditions["soilMoisture"]) > 540
                                  ? "Dry"
                                  : int.parse(conditions["soilMoisture"]) > 470
                                      ? "Normal"
                                      : "Wet",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ])),
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 26),
                    height: 120,
                    width: 149,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Color(0xFFE1FFFA),
                    ),
                    child: Column(children: [
                      const Text(
                        "Soil Salinity",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(conditions["soilSalinity"],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          const Text("mg/L",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600))
                        ],
                      )
                    ])),
              ],
            ),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 26),
                    height: 120,
                    width: 149,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Color(0xFFFBF2E6),
                    ),
                    child: Column(children: [
                      const Text(
                        "Soil EC",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(conditions["soilEC"],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          const Text("μS/cm",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600))
                        ],
                      )
                    ])),
                Container(
                    margin: const EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 26),
                    height: 120,
                    width: 149,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Color(0xFFFDEAED),
                    ),
                    child: Column(children: [
                      const Text(
                        "Water Level",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              conditions["waterLevel"] == "0"
                                  ? "Low"
                                  : conditions["waterLevel"] == "1"
                                      ? "Medium"
                                      : "Good",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Material(
                        color: Color.fromARGB(255, 216, 223, 246),
                        borderRadius: BorderRadius.circular(20.0),
                        child: MaterialButton(
                          minWidth: 300,
                          height: 42.0,
                          child: const Text(
                            'Disease Detection',
                            style: TextStyle(color: Colors.black, fontSize: 20),
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
              ],
            )
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map conditions = snapshot.value as Map;
              conditions['key'] = snapshot.key;
              print(conditions["airHumidity"]);
              return listItem(conditions: conditions);
            },
          )),
    );
  }
}
