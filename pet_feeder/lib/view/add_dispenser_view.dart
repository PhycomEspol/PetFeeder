import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_feeder/config/util/constants.dart';
import 'package:pet_feeder/config/util/methods.dart';
import 'package:pet_feeder/domain/entities/dispenser.dart';
import 'package:pet_feeder/view/widgets/app_text_field.dart';
import 'package:pet_feeder/view/widgets/background_scaffold.dart';

class AddDispenserView extends StatefulWidget {
  const AddDispenserView({super.key});

  @override
  State<AddDispenserView> createState() => _AddDispenserViewState();
}

class _AddDispenserViewState extends State<AddDispenserView> {
  GoogleMapController? mapController;
  Set<Marker> _markers = {};

  final ImagePicker picker = ImagePicker();

  XFile? image;

  Dispenser dispenser = Dispenser();

  @override
  void initState() {
    super.initState();
  }

  Future<void> mapsInit() async {
    var position = await getCurrentLocation();
    debugPrint(
        "getCurrentLocation method: ${position?.latitude}, ${position?.longitude}");
    if (mounted) {
      dispenser.latitude = position?.latitude ?? 0;
      dispenser.longitude = position?.longitude ?? 0;
      _markers = Set.from(
        List.generate(
          dispensers.length,
          (index) {
            var dispenser = dispensers[index];
            return Marker(
              markerId: MarkerId(dispenser.id!),
              position: LatLng(dispenser.latitude!, dispenser.longitude!),
              infoWindow: InfoWindow(
                title: '${dispenser.id}: ${dispenser.name}',
                snippet: dispenser.faculty,
              ),
            );
          },
        ),
      );
      setState(() {});
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(dispenser.latitude!, dispenser.longitude!),
              zoom: 17,
            ),
          ),
        );
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapsInit();
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      const String newDispenserMarkerId = "newDispenser";
      Marker? existingMarker;

      for (Marker marker in _markers) {
        if (marker.markerId.value == newDispenserMarkerId) {
          existingMarker = marker;
          break;
        }
      }

      if (existingMarker != null) {
        _markers.remove(existingMarker);
      }

      _markers.add(
        Marker(
          markerId: const MarkerId(newDispenserMarkerId),
          infoWindow: InfoWindow(
            title: '${dispenser.id}: ${dispenser.name}',
            snippet: dispenser.faculty,
          ),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            debugPrint(
                "Nuevo marcador en: ${newPosition.latitude}, ${newPosition.longitude}");
          },
        ),
      );
      dispenser.latitude = position.latitude;
      dispenser.longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      background: backgroundAddDispenser,
      appBar: AppBar(
        title: const Text('Agregar Dispensador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              setState(() {});
              var db = FirebaseFirestore.instance;
              final storageRef = FirebaseStorage.instance.ref();
              final imagePath = File(image!.path);
              final imageReference = storageRef.child(
                  "dispenser/${dispenser.id}.${imagePath.path.split('.').last}");
              try {
                await imageReference.putFile(imagePath);
              } on FirebaseException catch (e) {
                debugPrint("Error uploading image: $e");
              }

              try {
                dispenser.image = await imageReference.getDownloadURL();
                setState(() {});

                final docRef = db
                    .collection("dispensers")
                    .withConverter(
                      fromFirestore: Dispenser.fromFirestore,
                      toFirestore: (Dispenser dispenser, options) =>
                          dispenser.toJson(),
                    )
                    .doc(dispenser.id);
                await docRef.set(dispenser);
                showToast('Dispensador registrado');
                if (context.mounted) context.pop();
              } on FirebaseException catch (e) {
                debugPrint("Error saving dispenser: $e");
                showToast(e.message ?? 'Error desconocido');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    image = await picker.pickImage(source: ImageSource.gallery);
                    setState(() {});
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Theme.of(context).primaryColor,
                    child: image != null
                        ? Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.image,
                            size: 50,
                            color: Theme.of(context).canvasColor,
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'ID Dispensador',
                        onChanged: (id) => dispenser.id = id,
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Nombre',
                        onChanged: (name) => dispenser.name = name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(8),
                hint: const Text('Seleccionar Facultad'),
                isExpanded: true,
                underline: const SizedBox.shrink(),
                items: List.generate(
                  faculties.length - 1,
                  (index) {
                    String faculty = faculties[index + 1];
                    return DropdownMenuItem(
                      value: faculty,
                      child: Text(faculty),
                    );
                  },
                ),
                onChanged: (String? value) {
                  setState(() {
                    dispenser.faculty = value!;
                  });
                },
                value: dispenser.faculty,
              ),
            ),
            AppTextField(
              label: 'Número de mascotas',
              onChanged: (pets) => dispenser.pets = int.tryParse(pets),
              widthFactor: 1,
              keyboardType: TextInputType.number,
            ),
            AppTextField(
              label: 'API Key',
              onChanged: (apiKey) => dispenser.apiKey = apiKey,
              widthFactor: 1,
            ),
            ListTile(
              title: const Text('Horario de alimentación'),
              subtitle: Text(
                '${dispenser.refillSchedule}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    dispenser.refillSchedule = time.format(context);
                  });
                }
              },
            ),
            Text(
              'Ubicación',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(dispenser.latitude!, dispenser.longitude!),
                  zoom: 0,
                ),
                onMapCreated: _onMapCreated,
                onTap: _onMapTapped,
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
