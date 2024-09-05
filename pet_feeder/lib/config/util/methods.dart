import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_feeder/config/router/app_router.dart';
import 'package:pet_feeder/domain/entities/dispenser.dart';

Future<Position?> getCurrentLocation() async {
  if (await Geolocator.isLocationServiceEnabled()) {
    if (await Geolocator.checkPermission() != LocationPermission.denied) {
      return await Geolocator.getCurrentPosition();
    }
  }
  return null;
}

Future<List<Dispenser>> retrieveDispensers() async {
  var db = FirebaseFirestore.instance;
  var collection = await db.collection("dispensers").get().then(
    (querySnapshot) {
      debugPrint("Successfully completed");
      return querySnapshot.docs
          .map((e) => Dispenser.fromFirestore(e, null))
          .toList();
    },
    onError: (e) => debugPrint("Error completing: $e"),
  );
  return collection;
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
  );
}

Future<void> sendPasswordReset(
  String email,
  String toastMessage, {
  bool goToLogin = false,
}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    showToast(toastMessage);
    if (goToLogin) {
      AppRouter.router.go(AppPages.login);
    }
  } on FirebaseAuthException catch (e) {
    showToast(e.message ?? 'Error desconocido');
  }
}
