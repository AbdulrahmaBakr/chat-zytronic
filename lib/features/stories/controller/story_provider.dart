import 'package:chat/features/stories/model/story_models.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryProvider extends ChangeNotifier {
  StoryProvider(this._db);
  final FirebaseFirestore _db;

  Stream<List<Story>> stories() {
    return _db.collection('stories').orderBy('latestAt', descending: true).snapshots().map(
          (s) => s.docs.map(Story.fromDoc).toList(),
        );
  }
}
