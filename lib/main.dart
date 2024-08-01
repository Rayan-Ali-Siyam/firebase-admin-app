import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:fire_admin_app2/generated/firebase_options.dart';
import 'package:fire_admin_app2/pages/home_page.dart';
import 'package:fire_admin_app2/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "FlutterFireSample2",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static List<AuthProvider> signInProvider = [
    EmailAuthProvider(),
    // GoogleProvider(clientId: ClientIds.googleClientId),
    // FacebookProvider(clientId: ClientIds.facebookClientId),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 4020,
        minWidth: 480,
        defaultScale: true,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      title: 'FireAdminApp2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: signInProvider,
            actions: [
              AuthStateChangeAction<SignedIn>(
                (context, state) {
                  FirestoreService()
                      .isAdmin(FirebaseAuth.instance.currentUser!.email!)
                      .then((value) async => value
                          ? [
                              Get.snackbar(
                                "Succesful",
                                "You have succesfully Singed in.",
                                colorText: Colors.green,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 40.w,
                                ),
                              ),
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', (Route<dynamic> route) => false)
                            ]
                          : {
                              await FirebaseAuth.instance.signOut(),
                              Get.snackbar(
                                "Invalid Email",
                                "The given Email does not referres to an admin.",
                                colorText: Colors.red,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 40.w,
                                ),
                              ),
                            });
                },
              ),
            ],
          );
        },
        '/': (context) => const HomePage(),
      },
    );
  }
}
