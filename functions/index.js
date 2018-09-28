
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions


/*
 TODO: 
    - Setup another function to send to a topic, when another database is updated, figure
      out the strucure of this database
*/

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


// Send the AD  notification that was updated.  NOTE: only those that have subscribed
// to the advertisement topic will recieve the notification.
exports.sendAdNotification = functions.database.ref('topics/advertisement/{key}').onWrite((data, context) => {

    const datetime = context.timestamp;
    const datavalue = data.after.val();
    const companyName = datavalue.companyName;
    const websiteURL = datavalue.websiteURL;
    const content = datavalue.content;

    const payload = {
        notification:{
            title : companyName,
            body : content,
            badge : '1',
            sound : 'default'
        },
        data: {
            'source': 'advertisement',
           'websiteURL': websiteURL,
        }
    };

    // Send the message to the topic. notification will be recieved by those that subscribed to this topic
     return admin.messaging().sendToTopic('advertisement', payload);

});






// Send the notification to the topic that was updated.  NOTE: only those that have subscribed
// to the topic will recieve the notification.
exports.sendActionTopicNotification = functions.database.ref('topics/actions/{actionTopic}/{key}').onWrite((data, context) => {

    const actionTopic = context.params.actionTopic;
    const datetime = context.timestamp;
    const datavalue = data.after.val();
    const displayName = datavalue.displayName;
    const uid = datavalue.uid;
    const description = datavalue.description;

    const title = actionTopic + " by " + displayName;
    const body = description;

    const payload = {
        notification:{
            title : title,
            body : body,
            badge : '1',
            sound : 'default'
        },
        data: {
            'source': actionTopic,
            'uid': uid,
        }
    };

    // Send the message to the topic. notification will be recieved by those that subscribed to this topic
     return admin.messaging().sendToTopic(actionTopic, payload);

});


// We send out chat notification when a message is entered.  This
// indicates peer to peer communication, so we must retrieve the fcm token
// NOTE:  when this notfication table is updated from the app, it should also store
//       the datetime, so that can be accessed as well. 
exports.sendChatNotification = functions.database.ref('chat/{uidChannel}/{key}').onWrite((data, context) => {

    const datetime = context.timestamp;
   
    // The channel ID concatonates both UID id's (seperated by _) so we can split them and determine
    // the from and to.  
    const channelID = context.params.uidChannel;
    const pos = channelID.search("_"); 
    const uidFrom  = channelID.substr(0,pos);  // first uid is the From
    const uidTo = channelID.substr(pos+1);     // second uid is the To
    
    const datavalue = data.after.val();
    const title = datavalue.name + ' sent you a message';
    const body = datavalue.content;

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

            // NOTE: The line below is what we would use to send to a topic, subscribed
            //return admin.messaging().sendToTopic("topicOne", payload);

        }else{
            console.log('No data available in snapshot');
        }
    });



});