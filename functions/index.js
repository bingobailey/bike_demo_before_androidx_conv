
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions


/*
 TODO: 
    
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
    const datetime = context.timestamp;
    const title = 'Message from ' + uidFrom;

    const datavalue = data.after.val();
    const body = datavalue.msg;
  
    const payload = {
        notification:{
            title : title,
            body : body,
            badge : '1',
            sound : 'default'
        }
    };



    // We access the user we want to send the notification to, to retrieve the fcm-token
    // all fcm-tokens are saved under users/ uid  when they start up the app
    return admin.database().ref('users/' + uidTo).once('value').then(snapshot => {

        // NOTE: Unable to the code below to work. getUser appears to execute
        //       but updateRecord.displayName comes back as undefined
        // const uid = 'ZgrSJsAjeVeA8i11QPmGcse0k0h2';
        // const userProfileRecord = admin.auth().getUser(uid);
        // console.log('user profile displayname: ' + userProfileRecord.displayName) ;



        // if the snapshot has data, continue 
        if(snapshot.val()){
            const token = snapshot.val()['fcm-token']; // access the token
            console.log('sending to msg to device');
            return admin.messaging().sendToDevice(token,payload);
            //return admin.messaging().sendToTopic("topicOne", payload);

        }else{
            console.log('No data available in snapshot');
        }
    });



});