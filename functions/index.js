const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();


exports.addNewProduct = functions.firestore
    .document('products/{id}').onCreate((snap, context) => {
        const payload = {
            notification: {
                title: 'ផលិតផលថ្មី',
                body: 'Fast Technology បានបន្ថែមផលិលផលថ្មី',
                badge: '1',
                sound: 'default',
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            data: {
                title: 'ផលិតផលថ្មី',
                body: 'Fast Technology បានបន្ថែមផលិលផលថ្មី',
            },
        }

        return admin.messaging().sendToTopic('fasttech', payload).then(() => {
            console.log('------ success ------');
        })

    });
