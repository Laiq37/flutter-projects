const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.myFunction = functions.firestore.document("chat/{message}").onCreate((snapShot, context) => {
    return admin.messaging().sendToTopic("chat", {
        notification: {
            title: snapShot.data().UserName, body: snapShot.data().Text,
        },
    });
});
