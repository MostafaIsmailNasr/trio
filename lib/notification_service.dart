import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';

import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';




class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final _localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();

  init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification?.title}');
        showLocalNotification(
            id: 1,
            title: message.notification!.title ?? "",
            body: message.notification!.body ?? "",
            payload: json.encode(message.data));
      }
    });
    /***
     *
     *
     *
     * {image: http://mega.mtjrsahl-ksa.com, click_id: 2839, body: edweqdwedewqewqef, title: test, click_action: instructor}
     * */
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");

      // if (message.data["click_action"] == "instructor") {
      //   int _yourId = int.tryParse(message.data["click_id"]) ?? 0;
      //   TeachersBinding().dependencies();
      //   if (Get.context != null) {
      //     Navigator.of(Get.context!).push(
      //       MaterialPageRoute(
      //           builder: (_) => TeacherDetailsScreen(_yourId.toString())),
      //     );
      //   }
      // } else if (message.data["click_action"] == "course") {
      //   int _yourId = int.tryParse(message.data["click_id"]) ?? 0;
      //   CourseDetailsBinding().dependencies();
      //   if (Get.context != null) {
      //     Navigator.of(Get.context!).push(
      //       MaterialPageRoute(
      //           builder: (_) => CourseDetailsScreen(_yourId.toString())),
      //     );
      //   }
      // } else if (message.data["click_action"] == "home") {
      //   //int _yourId = int.tryParse(message.data["click_id"]) ?? 0;
      //
      //   //Get.context
      // } else if (message.data["click_action"] == "support") {
      //   if (Get.context != null) {
      //     Get.offAll(ParentMainScreen(selectedIndex:8), binding: HomeBinding());
      //   }

      // }
    });
  }

  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
    print("onMessageOpenedApp==>1${payload}");
  }

  void selectNotification(NotificationResponse? payload) {
    print("onMessageOpenedApp==>2${payload?.payload}");
    // if (payload != null) {
    //   if (payload.payload != null) {
    //     print("click_action");
    //     var message = json.decode(payload.payload!);
    //     print("click_action=>" + message["click_id"]);
    //     if (message["click_action"] == "instructor") {
    //       int _yourId = int.tryParse(message["click_id"]) ?? 0;
    //       TeachersBinding().dependencies();
    //       if (Get.context != null) {
    //         Navigator.of(Get.context!).push(
    //           MaterialPageRoute(
    //               builder: (_) => TeacherDetailsScreen(_yourId.toString())),
    //         );
    //       }
    //
    //
    //     } else if (message["click_action"] == "course") {
    //       int _yourId = int.tryParse(message["click_id"]) ?? 0;
    //       CourseDetailsBinding().dependencies();
    //       if (Get.context != null) {
    //         Navigator.of(Get.context!).push(
    //           MaterialPageRoute(
    //               builder: (_) => CourseDetailsScreen(_yourId.toString())),
    //         );
    //       }
    //     } else if (message["click_action"] == "home") {
    //       //int _yourId = int.tryParse(message.data["click_id"]) ?? 0;
    //     } else if (message["click_action"] == "support") {
    //       if (Get.context != null) {
    //         Get.offAll(ParentMainScreen(selectedIndex:8), binding: HomeBinding());
    //       }
    //     }
    //
    //     if (payload != null && payload.payload!.isNotEmpty) {
    //       behaviorSubject.add(payload.payload!);
    //     }
    //   }
    // }
  }

  Future<NotificationDetails> _notificationDetails(String? image ) async {

    final String bigPicturePath = image!=null?await _downloadAndSaveFile(
        (image??""),image!=null?basename(image):"" /*'bigPicture.jpg'*/):"";
    final String bigPicturePathBase64 =  image!=null?await _base64encodedImage((image??"")):"";

    final DarwinNotificationDetails? darwinNotificationDetails =
    image!=null?DarwinNotificationDetails(attachments: <DarwinNotificationAttachment>[
      DarwinNotificationAttachment(
        bigPicturePath,
        hideThumbnail: true,
      )
    ]):null;

    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
            bigPicturePathBase64), //Base64AndroidBitmap(bigPicture),
        largeIcon:image!=null? ByteArrayAndroidBitmap.fromBase64String(bigPicturePathBase64):null,
        // contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        // summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);

    // final BigPictureStyleInformation bigPictureStyleInformation =
    // BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
    //     largeIcon: FilePathAndroidBitmap(largeIconPath),
    //     contentTitle: 'overridden <b>big</b> content title',
    //     htmlFormatContentTitle: true,
    //     summaryText: 'summary <i>text</i>',
    //     htmlFormatSummaryText: true);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '965',
      'Eclasses Public Notification',
      groupKey: 'com.e_class.course',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      largeIcon: image!=null?FilePathAndroidBitmap(bigPicturePath):null,
      styleInformation: image!=null?bigPictureStyleInformation:null,
      //largeIcon: image!=null?  /* ByteArrayAndroidBitmap(bigPicture)*/:null,
      // styleInformation: BigPictureStyleInformation(
      //   FilePathAndroidBitmap(bigPicture),
      //   hideExpandedLargeIcon: false,
      // ),
      //color: const Color(0xff2196f3),
    );





    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      behaviorSubject
          .add(details.notificationResponse!.notificationResponseType.name);
    }
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinNotificationDetails,
        //darwinNotificationDetails,
        macOS: darwinNotificationDetails);

    return platformChannelSpecifics;
  }

  /*Future<NotificationDetails> _notificationDetails(String? url) async {
    http.Response response = await http.get(Uri.parse(url??""));
    AndroidNotificationDetails androidNotificationDetails =
    const  AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      icon: '@drawable/ic_launcher',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      color: Color(0x00000010),
      enableVibration: false,
      //vibrationPattern: 10
    );
    if(response.statusCode == 200){
      final image = response.bodyBytes;
      BigPictureStyleInformation androidImage =
      BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(image)),
      );
      androidNotificationDetails = AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          icon: '@drawable/ic_launcher',
          channelDescription: 'description',
          importance: Importance.max,
          priority: Priority.max,
          styleInformation: androidImage,
          playSound: true,
          sound: null
      );
    }

    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
        badgeNumber: 10,
        presentBadge: true,
        presentAlert: true,
        attachments: [DarwinNotificationAttachment('images/account/location.png')]
      //presentSound: true
    );

    return  NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }*/


  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if(payload!=null) {
      print(jsonDecode(payload)["image"]);
    }
    final platformChannelSpecifics = await _notificationDetails(payload!=null?(jsonDecode(payload)["image"]):null);
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
// Future<Uint8List> downloadLargeIcon(String imageUrl) async {
//   final response = await http.get(Uri.parse(imageUrl));
//   if (response.statusCode == 200) {
//     return response.bodyBytes;
//   } else {
//     throw Exception('Failed to download large icon.');
//   }
// }

// Future<String> _downloadAndSaveFile(String url, String fileName) async {
//   final Directory directory = await getApplicationDocumentsDirectory();
//   final String filePath = '${directory.path}/$fileName';
//   final http.Response response = await http.get(Uri.parse(url));
//   final File file = File(filePath);
//   await file.writeAsBytes(response.bodyBytes);
//   print("filePath==>");
//   print(filePath);
//   return filePath;
// }
Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<String> _base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}

Future<String> downloadAndSaveImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/notification_image.png';
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}


