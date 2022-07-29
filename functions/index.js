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


exports.addNewOrder = functions.firestore
    .document('orders/{id}').onCreate((snap, context) => {
        const payload = {
            notification: {
                title: 'ដាក់ទិញទំនិញ',
                body: `អតិថិជនឈ្មោះ ${snap.data().name} លេខទូរស័ព្ទ\t ${snap.data().phone} បានដាក់ទិញទំនិញ`,
                badge: '1',
                sound: 'default',
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            data: {
                title: 'ដាក់ទិញទំនិញ',
                body: `អតិថិជនឈ្មោះ ${snap.data().name} លេខទូរស័ព្ទ\t ${snap.data().phone} បានដាក់ទិញទំនិញ`,
            },
        }

        return admin.messaging().sendToTopic('admin', payload).then(() => {
            console.log('------ success ------');
        })

    });
