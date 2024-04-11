import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:muscel_meals/custom_widgets/custom_dropdown.dart';
import 'package:muscel_meals/firebase_options.dart';
import 'package:muscel_meals/pages/bowl-summary_page.dart';
import 'package:muscel_meals/pages/customize-bowl_page.dart';
import 'package:muscel_meals/pages/login_page.dart';
import 'package:muscel_meals/pages/logged-in-logged-out_page.dart';
import 'package:muscel_meals/pages/old-order_page.dart';
import 'package:muscel_meals/pages/register_page.dart';
import 'pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Value(),
        ),
        ChangeNotifierProvider(
          create: (_) => BowlNotifier(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.orange,
          fontFamily: GoogleFonts.prompt().fontFamily,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.5),
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: GoogleFonts.carterOne().fontFamily,
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              side: MaterialStateProperty.all(
                const BorderSide(
                  width: 3,
                  color: Colors.orange,
                ),
              ),
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              side: MaterialStateProperty.all(
                const BorderSide(
                  width: 3,
                  color: Colors.orange,
                ),
              ),
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
          ),
        ),
        home: const MainPage(),
        initialRoute: 'MainPage',
        routes: {
          'Home': (context) => const Home(),
          'SignIn': (context) => const SignIn(),
          'SignUp': (context) => const SignUp(),
          'MainPage': (context) => const MainPage(),
          //'Customize': (context) => const CustomizeBowl(),
          //'BowlSummary': (context) => const BowlSummary(),
        },
      ),
    );
  }
}
