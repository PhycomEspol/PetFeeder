import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    required this.background,
    required this.body,
  });

  final AppBar? appBar;
  final Widget body;
  final String background;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SvgPicture.asset(
              background,
              fit: BoxFit.cover,
            ),
          ),
          body,
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
