const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

//Soil Salinity
exports.soilSalinityFunction = functions.database
  .ref("tomato/soilSalinity")
  .onUpdate((evt: any) => {
    const getNotificationState = (prev: number, newValue: number) => {
      if (prev >= 0.5 && newValue < 0.5) return "Low";
      else if (prev <= 2.5 && newValue > 2.5) return "high";
      else return "normal";
    };
    const prevValue = parseInt(evt.before.val()) / 640;
    const newValue = parseInt(evt.after.val()) / 640;
    const notificationState = getNotificationState(prevValue, newValue);
    const payload = {
      notification: {
        title: "Soil Salinity Alert",
        body: `The Soil Salinity is ${notificationState}`,
        badge: "1",
        sound: "default",
      },
    };
    const allToken = [
      "dWctyJ1lSK-6ljP004GBER:APA91bGD1j8_AcEgH4uRXKjA_heNV-e_H1TuLL7ihfvLYnZr8DUCI1o-UXTJxnatRb-bhTYI0VcW-TpR4HFwnP01vlFGmJiSgCtwCfIUy8sSlNDDmSOANyapaGv2j1YWNqykGRlll-dB",
    ];

    console.log("token available");
    console.log(prevValue);
    console.log(newValue);
    // console.log(parseInt(evt.after.val()) >= 285);
    console.log(notificationState);
    if (
      allToken.length > 0 &&
      (notificationState == "Low" || notificationState == "high")
    ) {
      admin
        .messaging()
        .sendToDevice(allToken, payload)
        .then((response: any) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error: any) => {
          console.log("Error sending message:", error);
        });
    }
  });

// Water Level

exports.waterLevel = functions.database
  .ref("tomato/waterLevel")
  .onUpdate((evt: any) => {
    const getNotificationState = (prev: string, newValue: string) => {
      if (prev != newValue && newValue == "0") return "Low";
      else if (prev != newValue && newValue == "2") return "Very Good";
      else return "normal";
    };
    const prevValue = evt.before.val();
    const newValue = evt.after.val();
    const notificationState = getNotificationState(prevValue, newValue);
    const payload = {
      notification: {
        title: "Water Level Alert",
        body: `The Water Level is ${notificationState}`,
        badge: "1",
        sound: "default",
      },
    };
    const allToken = [
      "dWctyJ1lSK-6ljP004GBER:APA91bGD1j8_AcEgH4uRXKjA_heNV-e_H1TuLL7ihfvLYnZr8DUCI1o-UXTJxnatRb-bhTYI0VcW-TpR4HFwnP01vlFGmJiSgCtwCfIUy8sSlNDDmSOANyapaGv2j1YWNqykGRlll-dB",
    ];
    console.log("token available");
    console.log(prevValue);
    console.log(newValue);
    console.log(notificationState);
    if (
      allToken.length > 0 &&
      (notificationState == "Low" || notificationState == "Very Good")
    ) {
      admin
        .messaging()
        .sendToDevice(allToken, payload)
        .then((response: any) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error: any) => {
          console.log("Error sending message:", error);
        });
    }
  });
