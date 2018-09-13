
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

/*
 TODO: 
    - reorg fcm-token to users/name/token   so that each user can store their token in
    the structure.   Test to make sure it works. 

   - pull data out of the event (with exisiing notification structure)
   - reorg notification structure to notifications / chat or noticiations / newbikeadded
   - test with new structure


*/




const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


exports.sendNotification = functions.database.ref('notification/{uidFrom}/{uidTo}').onWrite((data, context) => {


    console.log("UID From= " + context.params.uidFrom);
    console.log("UID To= " + context.params.uidTo);
    console.log("timestamp = " + context.timestamp);

    const datavalue = data.after.val();
    console.log("message = " + datavalue.msg);
  
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