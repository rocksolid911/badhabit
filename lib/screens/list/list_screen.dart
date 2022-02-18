import 'package:animations/animations.dart';
import 'package:badhabit/constants.dart';
import 'package:badhabit/database/habits_database.dart';
import 'package:badhabit/helpers/current_goal_helper.dart';
import 'package:badhabit/models/habit.dart';
import 'package:badhabit/models/history_item.dart';
import 'package:badhabit/models/history_item_type.dart';
import 'package:badhabit/screens/components/bottom_ad_banner.dart';
import 'package:badhabit/screens/components/top_ad_button.dart';
import 'package:badhabit/screens/details/details_screen.dart';
import 'package:badhabit/screens/edit/edit_screen.dart';
import 'package:badhabit/screens/list/components/list_item.dart';
import 'package:badhabit/screens/list/components/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  static const ContainerTransitionType _transitionType =
      ContainerTransitionType.fade;
  static const double _fabDimension = 56.0;

  String? _filter;
  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    HabitsDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: NavDrawer(
        closeCallback: () {
          Navigator.of(context).pop();
        },
      ),
      drawerEnableOpenDragGesture: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryBlackColor,
      body: GestureDetector(
        onTap: _unFocus,
        child: Column(
          children: [
            SizedBox(
              height: SizerUtil.deviceType == DeviceType.mobile ? 5.h : 2.5.h,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 14,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        _key.currentState!.openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        color: Colors.white.withOpacity(0.9),
                        size: SizerUtil.deviceType == DeviceType.mobile
                            ? 6.5.w
                            : 4.w,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        cursorColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _filter = value;
                          });
                        },
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: SizerUtil.deviceType == DeviceType.mobile
                              ? 12.sp
                              : 8.sp,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            //fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const TopAdButton(),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: HabitsDatabase.instance.getAll(_filter),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final habits = snapshot.data as List<Habit>;
                    return RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(const Duration(milliseconds: 1),
                            () {
                          setState(() {});
                        });
                      },
                      child: habits.isEmpty
                          ? Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  (_filter == null || _filter!.isEmpty)
                                      ? 'No Bad Habits'
                                      : 'Nothing found',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.mobile
                                        ? 16.sp
                                        : 12.sp,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 4,
                              ),
                              itemCount: habits.length,
                              itemBuilder: (context, index) {
                                final habit = habits[index];
                                return _OpenContainerWrapper(
                                  habit: habit,
                                  beforeCallback: _unFocus,
                                  transitionType: _transitionType,
                                  onClosed: _onClosed,
                                  closedBuilder: (
                                    BuildContext context,
                                    void Function() action,
                                  ) {
                                    final difference = DateTime.now()
                                        .difference(habit.dateTime);
                                    final currentGoal =
                                        CurrentGoalHelper.getCurrentGoal(
                                            difference.inDays);
                                    var percent = difference.inSeconds /
                                        currentGoal.inSeconds;

                                    percent = percent > 1
                                        ? 1
                                        : percent < 0
                                            ? 0
                                            : percent;

                                    int? record;
                                    if (difference.inDays > habit.record) {
                                      record = difference.inDays;

                                      if (habit.recordAttempt < habit.attempt) {
                                        var recordComment =
                                            'New record! Previous - ${habit.record} days.';

                                        if (habit.record == 0) {
                                          recordComment = 'New record!';
                                        }

                                        if (habit.record == 1) {
                                          recordComment =
                                              'New record! Previous - ${habit.record} day.';
                                        }

                                        final historyItem = HistoryItem(
                                          HistoryItemType.newRecord,
                                          DateTime.now(),
                                          recordComment,
                                          habit.id!,
                                        );

                                        HabitsDatabase.instance
                                            .insertHistoryItem(historyItem);
                                      }

                                      final updatedHabit = Habit(
                                        habit.name,
                                        habit.dateTime,
                                        habit.color,
                                        record,
                                        habit.attempt,
                                        habit.attempt,
                                        id: habit.id,
                                      );

                                      HabitsDatabase.instance
                                          .update(updatedHabit);
                                    } else {
                                      record = habit.record;
                                    }

                                    return _InkWellOverlay(
                                      openContainer: action,
                                      child: ListItem(
                                        attempt: habit.attempt,
                                        record: record,
                                        title: habit.name,
                                        color: Color(habit.color),
                                        currentGoal: currentGoal,
                                        indicatorPercent: percent,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Add',
        child: OpenContainer(
          transitionType: _transitionType,
          onClosed: _onClosed,
          openBuilder: (BuildContext context, VoidCallback _) {
            _unFocus();
            return const EditScreen();
          },
          closedElevation: 6.0,
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(_fabDimension / 2),
            ),
          ),
          openColor: Colors.white,
          closedColor: Colors.white,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return const SizedBox(
              height: _fabDimension,
              width: _fabDimension,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: primaryBlackColor,
                  size: 26,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAdBanner(
        screen: Screen.list,
        screenWidth: MediaQuery.of(context).size.width.toInt(),
      ),
    );
  }

  void _onClosed(Habit? habit) async {
    if (habit != null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return DetailsScreen(
              id: habit.id!,
              habit: habit,
            );
          },
        ),
      );
    }

    _searchController.clear();
    _filter = _searchController.value.text;
    setState(() {});
  }

  void _unFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
    required this.onClosed,
    required this.habit,
    required this.beforeCallback,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<Habit?> onClosed;
  final Habit habit;
  final VoidCallback beforeCallback;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<Habit>(
      openColor: primaryBlackColor,
      middleColor: primaryBlackColor,
      closedColor: primaryBlackColor,
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        beforeCallback();
        return DetailsScreen(
          id: habit.id!,
          habit: habit,
        );
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.child,
  });

  final VoidCallback? openContainer;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: SizerUtil.deviceType == DeviceType.mobile ? 10 : 15),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: openContainer,
        child: child,
      ),
    );
  }
}
