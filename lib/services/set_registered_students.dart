import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/registered_students.dart';

Future<void> setRegisteredStudents() async {
  final docRef = FirebaseFirestore.instance
      .collection('schoolData1')
      .doc('studentsList1');

  print('hit test');

  await docRef.set(
    {'registered_students': regNumbers},
    SetOptions(merge: true),
  ); // merge:true avoids overwriting any other doc fields

  print('Registered students list set/updated in Firestore.');
}
