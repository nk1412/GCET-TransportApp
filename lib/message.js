const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('your-collection/{docId}')
    .onCreate((snap, context) => {
        const newValue = snap.data();
        const payload = {
            notification: {
                title: 'New Notification',
                body: newValue.message,
            },
        };

        return admin.messaging().sendToTopic('your-topic', payload)
            .then((response) => {
                console.log('Successfully sent message:', response);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            });
    });