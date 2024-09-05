import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_feeder/config/router/app_router.dart';
import 'package:pet_feeder/config/theme/app_theme.dart';
import 'package:pet_feeder/domain/entities/dispenser.dart';

import 'percentage_icon.dart';

class DispenserCard extends StatelessWidget {
  const DispenserCard({super.key, required this.dispenser});

  final Dispenser dispenser;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        AppPages.dispenser,
        extra: dispenser.id!,
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.4,
        height: 150.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PercentageIcon(
                percentage: dispenser.currentCapacity!,
                size: 100,
                icon: Icons.pets,
                filledColor: dispenser.currentCapacity! <= 10 ? Colors.red : Theme.of(context).primaryColor,
                unfilledColor: const Color(AppTheme.terciaryColor),
              ),
              Text(dispenser.name!),
            ],
          ),
        ),
      ),
    );
  }
}
