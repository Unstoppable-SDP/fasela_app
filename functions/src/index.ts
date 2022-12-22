const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

exports.resetCreditsForFreeUsers = functions.pubsub
  .schedule("0 0 * * 0") //At 00:00 on Sunday.
  .onRun(async () => {
    let plantsrRef = db.collection("Plants").doc("wSaPwNbECIFCkPb1cStH");

    const plantData = await plantsrRef
      .get()
      .then((doc: any) => {
        return doc.data();
      })
      .catch((err: any) => {
        console.log("Error getting document", err);
      });

    const plants = plantsrRef.set({ ...plantData, age: plantData.age + 1 });
    return plants;
  });
