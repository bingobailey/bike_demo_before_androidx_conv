
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.helloWorld = functions.database.ref('notification/{id}').onWrite(evt => {
    const payload = {
        notification:{
            title : 'Message from Cloud',
            body : 'This is your body',
            badge : '1',
            sound : 'default'
        }
    };

    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            //return admin.messaging().sendToDevice(token,payload);
            return admin.messaging().sendToTopic("topicOne", payload);

        }else{
            console.log('No token available');
        }
    });

});