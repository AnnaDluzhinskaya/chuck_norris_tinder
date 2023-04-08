import 'package:chuck_norris_tinder/services/firestore_service.dart';
import 'package:chuck_norris_tinder/services/network_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((ref) => FirestoreService());
final networkProvider = Provider((ref) => NetworkService());
