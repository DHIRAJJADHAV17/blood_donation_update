import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/app/splash_screen/splash_screen.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/dashboard.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/home_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/status_listpage.dart';
import 'package:flutter_firebase/firebase_options.dart';

import 'features/user_auth/presentation/pages/infopage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD1_ifbzDztarLViIEEvAENmQH5-HpCWCk",
        appId: "1:445446349251:web:515671754bf3ebeb9e5d76",
        messagingSenderId: "445446349251",
        projectId: "fluttercrud-4d8fe",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/listpage': (context) => ListPages(),
        '/dashboard': (context) => DashBoard(),
        RequetInfopage.id: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is String) {
            return RequetInfopage(args);
          }
          return RequetInfopage('');
        },
      },
    );
  }
}
