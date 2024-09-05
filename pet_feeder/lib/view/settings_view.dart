import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  var refillSchedule = '12:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ajustes'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Horario de Alimentación'),
            subtitle: Text(refillSchedule),
            leading: const Icon(Icons.access_time),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  refillSchedule = time.format(context);
                });
              }
            },
          ),
          ListTile(
            title: const Text('Notificaciones por correo'),
            leading: const Icon(Icons.notifications_active),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
