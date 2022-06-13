import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
  //通知の初期化
  final notification = FlutterLocalNotificationsPlugin();
  notification
      .initialize(
        const InitializationSettings(
          iOS: IOSInitializationSettings(),
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      )
      .then((_) => notification.show(
          0,
          "テスト通知",
          "通知の内容",
          const NotificationDetails(
            android: AndroidNotificationDetails("channelId", "channelName"),
          )));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '通知テストアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '通知テスト'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var time_text = "ここに設定した時間が表示されます";
  void _setNotification() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now().add(Duration(days: 360)));
    final notification = FlutterLocalNotificationsPlugin();
    notification.zonedSchedule(
      0,
      "通知",
      "設定された時間になりました",
      tz.TZDateTime(tz.local, date!.year, date.month, date.day, 09, 00),
      const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName"),
        iOS: IOSNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    setState(() {
      time_text = "${date.year}年${date.month}月${date.day}日9時に通知を送ります";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '何分後に通知を出しますか??',
            ),
            Text(
              time_text,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setNotification,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
