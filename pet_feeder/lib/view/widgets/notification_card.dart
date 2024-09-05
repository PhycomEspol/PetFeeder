import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pet_feeder/config/theme/app_theme.dart';
import 'package:pet_feeder/domain/entities/dispenser_notification.dart';
import 'package:pet_feeder/view/widgets/percentage_icon.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(this.notification, {super.key});

  final DispenserNotification notification;

  @override
  Widget build(BuildContext context) {
    var percentage =
        double.parse((Random().nextDouble() * 20).toStringAsFixed(2));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: ListTile(
          isThreeLine: true,
          title: Text(notification.dispenserName),
          leading: PercentageIcon(
            percentage: percentage,
            size: 50,
            icon: Icons.pets,
            filledColor: percentage <= 10 ? Colors.red : Theme.of(context).primaryColor,
            unfilledColor: const Color(AppTheme.terciaryColor),
            info: percentage <= 10 ? '!' : null,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(notification.faculty,
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                    )),
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
