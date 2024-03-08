import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:web_appllication/provider/All_Depo_Select_Provider.dart';
import 'package:web_appllication/provider/assigned_user_provider.dart';
import 'package:web_appllication/provider/demandEnergyProvider.dart';
import 'package:web_appllication/provider/energy_provider.dart';
import 'package:web_appllication/provider/filteration_provider.dart';
import 'package:web_appllication/provider/hover_provider.dart';
import 'package:web_appllication/provider/internet_provider.dart';
import 'package:web_appllication/provider/key_provider.dart';
import 'package:web_appllication/provider/menuUserPageProvider.dart';
import 'package:web_appllication/provider/role_page_totalNum_provider.dart';
import 'package:web_appllication/provider/selected_row_index.dart';
import 'package:web_appllication/provider/text_provider.dart';
import 'package:web_appllication/provider/user_provider.dart';
import 'package:web_appllication/routeBuilder/fluro_router.dart';
import 'package:web_appllication/style.dart';

void main() async {
  Flurorouter.setupRouter();
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
        ChangeNotifierProvider(create: (_) => DemandEnergyProvider()),
        ChangeNotifierProvider(create: (_) => MenuUserPageProvider()),
        ChangeNotifierProvider<AssignedUserProvider>(
            create: (_) => AssignedUserProvider()),
        ChangeNotifierProvider<textprovider>(
          create: (context) => textprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
            create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => KeyProvider()),
        ChangeNotifierProvider(create: (context) => SelectedRowIndexModel()),
        ChangeNotifierProvider(create: (context) => AllDepoSelectProvider()),
        ChangeNotifierProvider(create: (context) => EnergyProvider()),
        ChangeNotifierProvider(create: (context) => HoverProvider()),
        ChangeNotifierProvider(create: (context) => FilterProvider()),
        ChangeNotifierProvider(create: (context) => RolePageTotalNumProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TATA POWER CONTROL PANEL',
        initialRoute: 'login',
        //  onGenerateRoute:Flurorouter.router.
        onGenerateRoute: Flurorouter.router.generator,
        theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStatePropertyAll(blue),
            thickness: const MaterialStatePropertyAll(7.0),
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
        // home:
        //  RoleScreen()
        // LoginRegister()
      ),
    );
  }
}
