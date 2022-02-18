import 'package:badhabit/models/history_item_type.dart';

class HistoryItem {
  int? id;
  HistoryItemType type;
  DateTime dateTime;
  String? comment;
  int fkHabitId;

  HistoryItem(this.type, this.dateTime, this.comment, this.fkHabitId,
      {this.id});

  static HistoryItem fromMap(Map<String, dynamic> data) {
    return HistoryItem(
      HistoryItemType.values[data['type'] as int],
      DateTime.parse(data['dateTime'] as String),
      data['comment'] as String?,
      data['FK_habit_id'] as int,
      id: data['id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'dateTime': dateTime.toIso8601String(),
      'comment': comment,
      'FK_habit_id': fkHabitId,
    };
  }
}
