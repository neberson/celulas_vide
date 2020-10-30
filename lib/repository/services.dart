
import 'package:firebase_auth/firebase_auth.dart';

Future getCurrentUserFirebase() async => await FirebaseAuth.instance.currentUser();