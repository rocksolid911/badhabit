class Habit {
  int? id;
  String name;
  DateTime dateTime;
  int color;
  int record;
  int recordAttempt;
  int attempt;

  Habit(this.name, this.dateTime, this.color, this.record, this.recordAttempt, this.attempt,
      {this.id});

  static Habit fromMap(Map<String, dynamic> data) {
    return Habit(
      data['name'] as String,
      DateTime.parse(data['dateTime'] as String),
      data['color'] as int,
      data['record'] as int,
      data['recordAttempt'] as int,
      data['attempt'] as int,
      id: data['id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateTime': dateTime.toIso8601String(),
      'color': color,
      'record': record,
      'recordAttempt': recordAttempt,
      'attempt': attempt,
    };
  }
}
