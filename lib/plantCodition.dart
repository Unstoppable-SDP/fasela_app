import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PlantCondition extends StatefulWidget {
  const PlantCondition({super.key});

  @override
  State<PlantCondition> createState() => _PlantConditionState();
}

class _PlantConditionState extends State<PlantCondition> {
  Query dbRef = FirebaseDatabase.instance.ref();
  Widget listItem({required Map conditions}) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 17),
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
                          Text(conditions["airHumidity"].values.toList().first,
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
                          Text(
                              conditions["airTemperature"]
                                  .values
                                  .toList()
                                  .first,
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
                          Text(conditions["soilMoisture"].values.toList().first,
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
                          Text(conditions["soilSalinity"].values.toList().first,
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
                          Text(conditions["soilEC"].values.toList().first,
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
                          Text(conditions["waterLevel"].values.toList().first,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                          const Text(" mL",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600))
                        ],
                      )
                    ])),
              ],
            ),
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
