const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { user } = require("firebase-functions/v1/auth");
const { UserInfo } = require("firebase-admin/auth");

admin.initializeApp(functions.config().functions);

var newData;

exports.notifications = functions.region('europe-west1').firestore.document("users/{id}").onCreate(async (snapshot, context) => {


    if (snapshot.empty) {
        console.log("No Devices");
        return;
    }

    newData = snapshot.data();

    const deviceIdTokens = await admin
        .firestore()
        .collection("AdminTokens")
        .get();

    var tokens = [];

    for (var token of deviceIdTokens.docs) {
        tokens.push(token.data().device_token); 
    }
    var payload = {
        notification: {
            title: "NearMe",
            body: snapshot.data().testo + " si è registrato/a!",
            sound: "default",
        },
        data: {
            "click_action" : "FLUTTER_NOTIFICATION_CLICK",
            "type": "newUser",
            "nome": snapshot.data().testo,
        }
    };

    try {
        const response = await admin.messaging().sendToDevice(snapshot.data().deviceIdTokens, payload);
        console.log("Notification sent successfully");
    } catch (err) {
        console.log(err);
    }
});