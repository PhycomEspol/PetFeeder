import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:pet_feeder/domain/entities/dispenser_notification.dart';
import 'package:pet_feeder/view/widgets/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos'),
      ),
      body: GroupedListView<DispenserNotification, DateTime>(
        elements: List.generate(
          10,
          (i) {
            var days = Random().nextInt(30);
            var hours = Random().nextInt(24);
            var date = i < 3 ? DateTime.now() : DateTime.now().subtract(Duration(
              days: days,
              hours: hours,
            ));
            return DispenserNotification(
              dispenserName: 'dispenserName $i',
              message: 'Message at $date',
              date: date,
              faculty: 'faculty',
              isRead: true,
            );
          },
        ),
        groupBy: (notification) => DateTime(
          notification.date.year,
          notification.date.month,
          notification.date.day,
        ),
        groupSeparatorBuilder: (date) => Stack(
          alignment: Alignment.center,
          children: [
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${date.month}/${date.day}',
                  style: TextStyle(color: Theme.of(context).canvasColor),
                ),
              ),
            ),
          ],
        ),
        itemBuilder: (_, notification) => NotificationCard(notification),
        useStickyGroupSeparators: true,
        floatingHeader: true,
        order: GroupedListOrder.DESC,
      ),
    );
  }
}
