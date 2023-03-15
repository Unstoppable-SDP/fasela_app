const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.soilMoisture = functions.database
  .ref("tomato/soilMoisture")
  .onUpdate((evt: any) => {
    const payload = {
      notification: {
        title: "VISITOR ALERT",
        body: "The soilMoisture is 285 > ",
        badge: "1",
        sound: "default",
      },
    };

    return admin
      .database()
      .ref("fcm-token")
      .once("value")
      .then((allToken: any) => {
        if (allToken.val()) {
          console.log("token available");
          const token = Object.keys(allToken.val() && evt.after.val() >= 285);
          console.log(token);
          admin
            .messaging()
            .sendToDevice(token, payload)
            .then((response: any) => {
              console.log("Successfully sent message:", response);
            })
            .catch((error: any) => {
              console.log("Error sending message:", error);
            });
        } else {
          console.log("No token available");
        }
      });
  });
