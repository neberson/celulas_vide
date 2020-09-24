
import 'package:firebase_auth/firebase_auth.dart';

getCurrentUserFirebase() async => await FirebaseAuth.instance.currentUser();