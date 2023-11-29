import 'package:app_settings/app_settings.dart';
import 'package:find_me/functions/SMSListener.dart';
import 'package:find_me/pages/listPos.dart';
import 'package:find_me/pages/map.dart';
import 'package:find_me/pages/sendmsg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

void main() async {
  await dotenv.load();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

messageHandler(SmsMessage message) async {
  print("received msg **********************" + message.body.toString());
}

class _MainAppState extends State<MainApp> {
  final List<Position> positions = [];
  final TextEditingController textEditingController = TextEditingController();
  var data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    listenForIncomingSMS();
    super.dispose();
  }
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    listenForIncomingSMS();
    _locationpermission();
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
        home: DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.black12,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.sms),
              icon: Icon(Icons.sms),
              label: 'Sms',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt),
              label: 'List',
            ),
            NavigationDestination(
              icon:  Icon(Icons.map_sharp),

              label: 'Map',
            ),
          ],
        ),


        body: <Widget>[
          SendMessagePage(),
          ListBestPosition(),
          MapViewWidget(),
        ][currentPageIndex]))
    );
  }

  void listenForIncomingSMS() async {
    final Telephony telephony = Telephony.instance;

    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage sms) {
          // Handle incoming SMS message here and execute a function.
          executeFunction(sms);
        },
        onBackgroundMessage: executeBackgroundFunction);
  }
}

Future<void> _locationpermission() async {
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  permission = await Geolocator.requestPermission();
  while (permission == LocationPermission.denied) {
    // Permissions are denied, next time you could try
    // requesting permissions again (this is also where
    // Android's shouldShowRequestPermissionRationale
    // returned true. According to Android guidelines
    // your App should show an explanatory UI now.
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    AlertDialog(
      content: Text('You need to change location permission in settings'),
      actions: [
        TextButton(
            onPressed: () => AppSettings.openAppSettings(),
            child: Text('Settings'))
      ],
    );
  }
}
