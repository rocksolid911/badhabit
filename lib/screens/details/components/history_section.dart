import 'package:auto_size_text/auto_size_text.dart';
import 'package:badhabit/constants.dart';
import 'package:badhabit/database/habits_database.dart';
import 'package:badhabit/models/history_item.dart';
import 'package:badhabit/screens/details/components/history_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HistorySection extends StatefulWidget {
  final int habitId;
  final Color color;
  final VoidCallback addCommentCallback;

  const HistorySection({
    Key? key,
    required this.habitId,
    required this.color,
    required this.addCommentCallback,
  }) : super(key: key);

  @override
  State<HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AutoSizeText(
                  'History',
                  style: mainTextStyle,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.white12),
                ),
                onPressed: widget.addCommentCallback,
                child: Text(
                  'Add comment',
                  style: TextStyle(
                    color: widget.color,
                    fontSize: SizerUtil.deviceType == DeviceType.mobile
                        ? 14.sp
                        : 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _buildLine(),
          const SizedBox(height: 5),
          FutureBuilder(
            future: HabitsDatabase.instance.getHistoryItems(widget.habitId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final historyItems = snapshot.data as List<HistoryItem>;
                return historyItems.isEmpty
                    ? Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            'History is empty',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.mobile
                                      ? 16.sp
                                      : 12.sp,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 0,
                          right: 0,
                          bottom: 5,
                          top: 2,
                        ),
                        itemCount: historyItems.length,
                        itemBuilder: (context, index) {
                          final historyItem = historyItems[index];
                          return HistoryListTile(
                            historyItem: historyItem,
                            color: widget.color,
                            deleteCallback: () async {
                              showDeleteDialog(
                                context,
                                'Are you sure you want to delete part of history? Please note that it cannot be recovered.',
                                () async {
                                  await HabitsDatabase.instance
                                      .deleteHistoryItem(historyItem.id!);
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                      );
              }

              return Center(
                  child: CircularProgressIndicator(color: widget.color));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLine(
      {Color? color,
      double width = 2000,
      double boarder = 0,
      double height = 1,
      double bottom = 0,
      double top = 0,
      bool horizontal = true}) {
    return Container(
      margin: EdgeInsets.only(
          right: boarder, left: boarder, bottom: bottom, top: top),
      color: color ?? Colors.grey[300],
      width: horizontal ? width : 1,
      height: horizontal ? height : height,
    );
  }
}
