import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:html/parser.dart';

class NotificationMessage {
  String? id;
  String? title;
  String? body;
  String? entityId;
  String? entityName;
  String? type;
  String? payload;

  NotificationMessage(Map<String, dynamic> message) {
    id = message['id'] ?? "";
    entityId = message['entityId'] ?? "";
    entityName = message['entityName'] ?? "";
    type = message['type'] ?? "";
    title = message['title'] ?? "";
    body = message['body'] == null ? "" : parse(message['body'] ?? '').documentElement!.text; // message['body'];body'];
  }
}

class FirebaseNotifications {
  FirebaseMessaging? _firebaseMessaging;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  BuildContext? context;
  String? _deviceName;
  String? _deviceToken;
  String? _deviceTokenPlatform;

  FirebaseNotifications() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  void setUpFirebase(BuildContext context) {
    this.context = context;

    _firebaseCloudMessagingListeners();
    _localNotificationsPluginListeners();
  }

  void _firebaseCloudMessagingListeners() {
    if (Platform.isIOS) _iOSPermission();
    _deviceTokenPlatform = Platform.operatingSystem + " " + Platform.operatingSystemVersion;
    _firebaseMessaging!.getToken().then((token) {
      // print("Firebase DeviceToken: [" + token + "]");
      _deviceToken = token;
    }).catchError((error) {
      print("Firebase DeviceToken Error: $error");
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print(message.data);
        NotificationMessage notificationMessage = NotificationMessage(message.data.cast<String, dynamic>());
        showLocalNotification(notificationMessage).then((value) {
          notifyCount();
        });
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('${message.data}');
      notifyCount();
    });

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((iosInfo) {
        print('Running on ${iosInfo.utsname.machine}');
        _deviceName = iosInfo.utsname.machine;
      });
    } else {
      deviceInfo.androidInfo.then((androidInfo) {
        print('Running on ${androidInfo.model}');
        _deviceName = androidInfo.model;
      });
    }
  }

  Future<void> _localNotificationsPluginListeners() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false);
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin!.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });

    await _flutterLocalNotificationsPlugin!.cancel(0);

    _flutterLocalNotificationsPlugin!.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showLocalNotification(NotificationMessage message) async {
    print(message.title.toString() + '/////////');
    var androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('fasttect', 'fasttect', channelDescription: 'fasttect', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(presentAlert: true, presentBadge: true);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin!.show(0, message.title, message.body, platformChannelSpecifics, payload: 'item x');
  }

  void _iOSPermission() {
    _firebaseMessaging?.requestPermission(sound: true, badge: true, alert: true);
    // _firebaseMessaging?.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
  }

  void notifyCount() {
    // AppScopedModel scopedModel = ScopedModel.of<AppScopedModel>(context, rebuildOnChange: true);
    // notificationService.getCount(scopedModel.userModel.refId).then((count) {
    //   scopedModel.nbNotification = count;
    //   scopedModel.notifyListeners();
    // });
  }

  String getDeviceName() => _deviceName!;

  Future<String?> getDeviceToken() async {
    if (_deviceToken != null && _deviceToken != '') {
      return _deviceToken;
    } else {
      _deviceToken = await _firebaseMessaging?.getToken();
      return _deviceToken!;
    }
  }

  String getDeviceTokenPlatform() => _deviceTokenPlatform!;

  void subscribeTopic(String? topic) {
    if (topic != null && topic != '') {
      _firebaseMessaging!.subscribeToTopic(topic);
    }
  }
}

FirebaseNotifications firebaseNotifications = FirebaseNotifications();
