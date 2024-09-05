import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_feeder/config/router/app_router.dart';

class RouterScaffold extends StatefulWidget {
  const RouterScaffold({super.key, required this.child});
  final Widget child;

  @override
  State<RouterScaffold> createState() => _RouterScaffoldState();
}

class _RouterScaffoldState extends State<RouterScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          var routes = [
            AppPages.home,
            AppPages.profile,
            AppPages.settings,
          ];
          context.push(routes[index]);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.food_bank_outlined),
            selectedIcon: Icon(
              Icons.food_bank,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Dispensadores',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
