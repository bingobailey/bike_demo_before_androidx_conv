
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions


/*
 TODO: 
    
   - plug in actual message into title and body of notification 
   - use an actual user in the authentication database to match up when you add the user
     to the notification database and try the admin.auth.getUser()
     see the code below 
https://github.com/firebase/functions-samples/blob/Node-8/fcm-notifications/functions/index.js

    - write some code in the app that updates the notificaton db via the program to see
      if the notification works
    - Setup another function to send to a topic, when another database is updated, figure
      out the strucure of this database
*/

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// We send out a notification when the notification database is updated.  This
// indicates peer to peer communication, so we must retrieve the token
// NOTE:  when this notfication table is updated from the app, it should also store
//       the datetime, so that can be accessed as well. 
exports.sendNotification = functions.database.ref('notification/{uidFrom}/{uidTo}').onWrite((data, context) => {

    const uidFrom = context.params.uidFrom;
    const uidTo = context.params.uidTo;

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



    // We access the user we want to send the notification to, to retrieve the fcm-token
    // all fcm-tokens are saved under users/ uid  when they start up the app
    return admin.database().ref('users/' + uidTo).once('value').then(snapshot => {

        // if the snapshot has data, continue 
        if(snapshot.val()){
            const token = snapshot.val()['fcm-token']; // access the toekn
            console.log('sending to msg to device');
            return admin.messaging().sendToDevice(token,payload);
            //return admin.messaging().sendToTopic("topicOne", payload);

        }else{
            console.log('No data available in snapshot');
        }
    });



});