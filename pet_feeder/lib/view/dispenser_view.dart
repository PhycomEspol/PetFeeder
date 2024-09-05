import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_feeder/config/util/constants.dart';
import 'package:pet_feeder/domain/entities/dispenser.dart';
import 'package:pet_feeder/view/widgets/background_scaffold.dart';

class DispenserView extends StatefulWidget {
  const DispenserView({super.key, required this.id});

  final String id;

  @override
  State<DispenserView> createState() => _DispenserViewState();
}

class _DispenserViewState extends State<DispenserView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  XFile? image;
  final ImagePicker picker = ImagePicker();
  Dispenser? dispenser;

  @override
  void initState() {
    super.initState();
  }

  Future<void> retrieveData() async {
    debugPrint('Retrieving data for dispenser ${widget.id}');
    final db = FirebaseFirestore.instance;
    final ref = db.collection("dispensers").doc(widget.id).withConverter(
          fromFirestore: Dispenser.fromFirestore,
          toFirestore: (Dispenser dispenser, _) => dispenser.toJson(),
        );
    final docSnap = await ref.get();
    if (docSnap.data() != null) {
      debugPrint('Document exists');
    } else {
      debugPrint('Document does not exist');
    }
    dispenser = docSnap.data() ?? Dispenser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: retrieveData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const BackgroundScaffold(
            background: backgroundDispenser,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return BackgroundScaffold(
          background: backgroundDispenser,
          appBar: AppBar(
            title: Text(dispenser!.name ?? 'Dispensador Test'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            image =
                                await picker.pickImage(source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Theme.of(context).primaryColor,
                            child: dispenser!.image != null
                                ? Image.network(
                                    dispenser!.image!,
                                    fit: BoxFit.cover,
                                  )
                                : image != null
                                    ? Image.file(
                                        File(image!.path),
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'ID: ',
                                  children: [
                                    TextSpan(
                                      text: widget.id,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Facultad: ',
                                  children: [
                                    TextSpan(
                                      text: dispenser!.faculty,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: null,
                                  child: Text('Alimentar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Rellenado última vez:\n'),
                            const Spacer(),
                            Text(
                              '${dispenser!.refillDate}\n',
                              style:
                                  TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Veces rellenado:\n'),
                            const Spacer(),
                            Text(
                              '${dispenser?.refillTimes}\n',
                              style:
                                  TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Estado:\n'),
                            const Spacer(),
                            Text(
                              '${dispenser?.currentCapacity}%\n',
                              style:
                                  TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListTile(
                      title: const Text('Horario de alimentación'),
                      subtitle: Text(dispenser!.refillSchedule!),
                      leading: const Icon(Icons.access_time),
                      trailing: const Icon(Icons.edit),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Ubicación',
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(dispenser!.latitude!, dispenser!.longitude!),
                        zoom: 20,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: Set.from(
                        List.generate(
                          dispensers.length,
                          (index) {
                            var dis = dispensers[index];
                            return Marker(
                              markerId: MarkerId(dis.id!),
                              position: LatLng(dis.latitude!, dis.longitude!),
                              infoWindow: InfoWindow(
                                title: '${dis.id}: ${dis.name}',
                                snippet: dis.faculty,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
