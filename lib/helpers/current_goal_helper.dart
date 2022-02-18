class CurrentGoalHelper {
  static const List<Duration> goals = [
    Duration(days: 1),
    Duration(days: 7),
    Duration(days: 30),
    Duration(days: 90),
    Duration(days: 180),
    Duration(days: 365),
    Duration(days: 730),
    Duration(days: 1095),
    Duration(days: 1825),
    Duration(days: 3650),
    Duration(days: 36500),
  ];

  static Duration getCurrentGoal(int differenceInDays) {
    for (var goal in goals) {
      if (goal.inDays > differenceInDays) {
        return goal;
      }
    }

    return goals.last;
  }

  static String getFirstMessage(int currentGoalInDays) {
    if (currentGoalInDays >= 365) {
      return '${currentGoalInDays ~/ 365}';
    } else {
      return '$currentGoalInDays';
    }
  }

  static String getSecondMessage(int currentGoalInDays) {
    if (currentGoalInDays >= 365) {
      return currentGoalInDays == 365 ? ' Year' : ' Years';
    } else {
      return currentGoalInDays == 1 ? ' Day' : ' Days';
    }
  }
}
