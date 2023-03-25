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
      "fuPBMywvTheeVJ_6z8sy3X:APA91bEQ62nVfcbKwU9zIZ2bqTjXXaTk84WSBAOofCde04vl7REuIaqCaV3AkowYxDf2dGTYt1K8n9FBIVcHrcPR0oip-XAcB6mv3oVEdz1l7wHn22H5vvPL_CsSjjbCOq4fyEX8GPut",
      "caRgqItmQqWb2YRjid5i9Y:APA91bGxVKDFR0cNd5POAE4aIjN3Nz_O-MVTUBYqqa3LdVfUYiwC63WbVlexYecfA6z3lPNQQ07muuTYQcybENDarnJg1liYzYv9OWRS2Ih4pb8ihSmK3OaBQnKTMqfQgg_TMg9GiJQg",
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
      "fuPBMywvTheeVJ_6z8sy3X:APA91bEQ62nVfcbKwU9zIZ2bqTjXXaTk84WSBAOofCde04vl7REuIaqCaV3AkowYxDf2dGTYt1K8n9FBIVcHrcPR0oip-XAcB6mv3oVEdz1l7wHn22H5vvPL_CsSjjbCOq4fyEX8GPut",
      "caRgqItmQqWb2YRjid5i9Y:APA91bGxVKDFR0cNd5POAE4aIjN3Nz_O-MVTUBYqqa3LdVfUYiwC63WbVlexYecfA6z3lPNQQ07muuTYQcybENDarnJg1liYzYv9OWRS2Ih4pb8ihSmK3OaBQnKTMqfQgg_TMg9GiJQg",
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
