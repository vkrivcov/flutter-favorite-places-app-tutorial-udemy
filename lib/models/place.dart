import 'package:uuid/uuid.dart';

class Place {
  static final uuid = Uuid();

  Place({
    required this.title,
    String? id
  }) : id = uuid.v4();

  final String id;
  final String title;
}