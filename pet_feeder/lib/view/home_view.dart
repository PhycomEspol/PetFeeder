import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_feeder/config/router/app_router.dart';
import 'package:pet_feeder/config/util/constants.dart';
import 'package:pet_feeder/domain/entities/dispenser.dart';
import 'package:pet_feeder/view/widgets/background_scaffold.dart';
import 'package:pet_feeder/view/widgets/dispenser_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var selected = {faculties[0]};
  List<Dispenser> items = [];
  List<Dispenser> currentItems = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    items = dispensers;
    currentItems = items;
    setState(() {});
  }

  List<Dispenser> filter(String faculty) {
    return items.where((element) => element.faculty == faculty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      background: backgroundHome,
      appBar: AppBar(
        title: const Text('Dispensadores'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppPages.addDispenser),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push(AppPages.notifications),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).canvasColor,
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () {
          showAdaptiveDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text(
                  'Advertencia',
                  textAlign: TextAlign.center,
                ),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Solo puedes dispensar comida una vez al día, anulando el horario definido por hoy',
                    ),
                    Row(
                      children: [
                        Checkbox.adaptive(value: false, onChanged: null),
                        Text('No mostrar de nuevo'),
                      ],
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: context.pop,
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).canvasColor,
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: context.pop,
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).canvasColor,
                    ),
                    child: const Text('Alimentar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.food_bank_outlined,
          size: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SegmentedButton<String>(
                      onSelectionChanged: (faculty) async {
                        setState(() {
                          selected = faculty;
                          currentItems = selected.first == 'All'
                              ? items
                              : filter(faculty.first);
                        });
                      },
                      showSelectedIcon: false,
                      segments: List.generate(
                        faculties.length,
                        (index) {
                          String faculty = faculties[index];
                          return ButtonSegment(
                            value: faculty,
                            label: Text(faculty),
                          );
                        },
                      ),
                      selected: selected,
                    ),
                  ],
                ),
              ),
              currentItems.isEmpty
                  ? Center(
                      child: Text(
                        'No hay dispensadores registrados',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : Wrap(
                      runSpacing: 5,
                      spacing: 5,
                      children: List.generate(
                        currentItems.length,
                        (index) {
                          var dispenser = currentItems[index];
                          return DispenserCard(dispenser: dispenser);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
