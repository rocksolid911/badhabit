import 'package:badhabit/models/history_item.dart';
import 'package:badhabit/models/history_item_type.dart';
import 'package:badhabit/screens/details/components/history_list_tile_with_subtitle.dart';
import 'package:badhabit/screens/details/components/history_list_tile_without_subtitle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class HistoryListTile extends StatelessWidget {
  final HistoryItem historyItem;
  final Color color;
  final VoidCallback deleteCallback;

  const HistoryListTile({
    Key? key,
    required this.historyItem,
    required this.color,
    required this.deleteCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return historyItem.comment == null
        ? HistoryListTileWithoutSubtitle(
            iconData: _getIconData(),
            color: color,
            title:
                DateFormat('dd MMMM yyyy, HH:mm').format(historyItem.dateTime),
            deleteCallback: deleteCallback,
          )
        : HistoryListTileWithSubtitle(
            iconData: _getIconData(),
            color: color,
            title:
                DateFormat('dd MMMM yyyy, HH:mm').format(historyItem.dateTime),
            subtitle: historyItem.comment!,
            deleteCallback: deleteCallback,
          );
  }

  IconData _getIconData() {
    switch (historyItem.type) {
      case HistoryItemType.beginningOfJourney:
        return LineIcons.plus;
      case HistoryItemType.relapse:
        return LineIcons.alternateRedo;
      case HistoryItemType.comment:
        return LineIcons.comment;
      case HistoryItemType.newRecord:
        return LineIcons.medal;
      default:
        return LineIcons.circle;
    }
  }
}
