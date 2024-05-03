import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:web_appllication/pmis_oAndm_split_screen.dart.dart';
import 'package:web_appllication/provider/provider_admin/All_Depo_Select_Provider.dart';
import 'package:web_appllication/provider/provider_admin/assigned_user_provider.dart';
import 'package:web_appllication/provider/provider_admin/date_provider.dart';
import 'package:web_appllication/provider/provider_admin/demandEnergyProvider.dart';
import 'package:web_appllication/provider/provider_admin/energy_provider.dart';
import 'package:web_appllication/provider/provider_admin/filteration_provider.dart';
import 'package:web_appllication/provider/provider_admin/hover_provider.dart';
import 'package:web_appllication/provider/provider_admin/internet_provider.dart';
import 'package:web_appllication/provider/provider_admin/key_provider.dart';
import 'package:web_appllication/provider/provider_admin/role_page_totalNum_provider.dart';
import 'package:web_appllication/provider/provider_admin/selected_row_index.dart';
import 'package:web_appllication/provider/provider_admin/text_provider.dart';
import 'package:web_appllication/provider/provider_admin/user_provider.dart';
import 'package:web_appllication/provider/provider_user/checkbox_provider.dart';
import 'package:web_appllication/provider/provider_user/energy_provider.dart';
import 'package:web_appllication/provider/provider_user/hover_provider.dart';
import 'package:web_appllication/provider/provider_user/key_provider.dart';
import 'package:web_appllication/provider/provider_user/summary_provider.dart';
import 'package:web_appllication/routeBuilder/fluro_router.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

void main() async {
  FluroRouting.setupRouter();
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCrSwVB12UIZ_wiLcsIqDeXb3cP6QKkMgM',
          appId: '1:787886302853:web:a13e1fc1f32187fcc26bec',
          messagingSenderId: '787886302853',
          storageBucket: "tp-zap-solz.appspot.com",
          projectId: 'tp-zap-solz'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DemandEnergyProviderAdmin()),
        ChangeNotifierProvider<AssignedUserProviderAdmin>(
            create: (_) => AssignedUserProviderAdmin()),
        ChangeNotifierProvider<textproviderAdmin>(
          create: (context) => textproviderAdmin(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProviderAdmin(),
        ),
        ChangeNotifierProvider<ConnectivityProviderAdmin>(
            create: (context) => ConnectivityProviderAdmin()),
        ChangeNotifierProvider(create: (context) => KeyProviderAdmin()),
        ChangeNotifierProvider(create: (context) => KeyProviderUser()),
        ChangeNotifierProvider(
            create: (context) => SelectedRowIndexModelAdmin()),
        ChangeNotifierProvider(
            create: (context) => AllDepoSelectProviderAdmin()),
        ChangeNotifierProvider(create: (context) => EnergyProviderAdmin()),
        ChangeNotifierProvider(create: (context) => EnergyProviderUser()),
        ChangeNotifierProvider(create: (context) => HoverProviderAdmin()),
        ChangeNotifierProvider(create: (context) => HoverProviderUser()),
        ChangeNotifierProvider(create: (context) => FilterProviderAdmin()),
        ChangeNotifierProvider(create: (context) => CheckboxProviderUser()),
        ChangeNotifierProvider(create: (context) => SummaryProviderUser()),
        ChangeNotifierProvider(create: (context) => SummaryProviderAdmin()),
        ChangeNotifierProvider(
            create: (context) => RolePageTotalNumProviderAdmin()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TATA POWER CONTROL PANEL',
          // initialRoute: 'login',
          //  onGenerateRoute:Flurorouter.router.
          onGenerateRoute: FluroRouting.router.generator,
          theme: ThemeData(
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: const MaterialStatePropertyAll(true),
              thumbColor: MaterialStatePropertyAll(blue),
              thickness: const MaterialStatePropertyAll(5.0),
              trackVisibility: const MaterialStatePropertyAll(true),
            ),
            primarySwatch: Colors.blue,
            dividerColor: grey,
            fontFamily: 'Montserrat',
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  6,
                ),
                borderSide: BorderSide(
                  color: grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  6,
                ),
                borderSide: BorderSide(
                  color: blue,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusColor: almostWhite,
              labelStyle: bodyText2White60,
            ),
          ),
          // home: const PmisAndOAndMScreen()
          //  RoleScreen()
          // LoginRegister()
          ),
    );
  }
}

void listenToFirestoreChanges() async {
  print("Background Listening Started");
  FirebaseFirestore.instance
      .collection("unAssignedRole")
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docChanges.isNotEmpty &&
        snapshot.docChanges.first.type == DocumentChangeType.added) {
      playNotificationTone();
    }
  });
}

Future playNotificationTone() async {
  final player = AudioPlayer();

  await player.play(
      DeviceFileSource('assets/notification_sound/notification.mp3'),
      volume: 1.0,
      mode: PlayerMode.lowLatency);
}
