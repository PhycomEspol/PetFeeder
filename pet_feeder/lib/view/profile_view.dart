import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_feeder/config/router/app_router.dart';
import 'package:pet_feeder/config/util/methods.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? user;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then(
                    (_) => context.go(AppPages.login),
                  );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () async {
                  await picker
                      .pickImage(source: ImageSource.gallery)
                      .then((picked) {
                    if (picked == null) return null;
                    showAdaptiveDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text('Nueva Foto de Perfil'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('¿Desea guardar los cambios?'),
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 50,
                                child: ClipOval(
                                  child: Image.file(
                                    File(picked.path),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final storageRef =
                                    FirebaseStorage.instance.ref();
                                final imagePath = File(picked.path);
                                final imageReference = storageRef.child(
                                    "profiles/${user?.uid}.${imagePath.path.split('.').last}");
                                try {
                                  await imageReference.putFile(imagePath);
                                } on FirebaseException catch (e) {
                                  debugPrint("Error al cargar la imagen: $e");
                                }

                                user?.updatePhotoURL(
                                    await imageReference.getDownloadURL());
                                showToast('Foto de perfil actualizada');
                                setState(() {});
                                if (context.mounted) context.pop();
                              },
                              child: const Text('Guardar'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 50,
                  child: user?.photoURL != null
                      ? ClipOval(
                        child: Image.network(
                            user!.photoURL!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator();
                            },
                          ),
                      )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Name'),
              subtitle: TextField(
                controller: TextEditingController(text: user!.displayName),
                decoration: const InputDecoration(
                  hintText: 'No registrado',
                  border: InputBorder.none,
                ),
                onSubmitted: (newName) async {
                  if (newName.isEmpty || newName == user!.displayName) {
                    showToast('Nombre no válido o igual al actual');
                  } else {
                    await user?.updateDisplayName(newName);
                    showToast('Nombre actualizado');
                  }
                },
              ),
              leading: const Icon(Icons.person),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: TextField(
                controller: TextEditingController(text: user!.email),
                decoration: const InputDecoration(
                  hintText: 'No registrado',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (newEmail) async {
                  if (newEmail.isEmpty || newEmail == user!.email) {
                    showToast('Email no válido o igual al actual');
                  } else {
                    try {
                      await user?.verifyBeforeUpdateEmail(newEmail);
                      showToast(
                        'Se ha enviado un correo de verificación a $newEmail',
                      );
                    } on FirebaseAuthException catch (e) {
                      showToast(e.message ?? 'Error desconocido');
                    }
                  }
                },
              ),
              leading: const Icon(Icons.email),
              trailing: Tooltip(
                message: user!.emailVerified
                    ? 'Email verificado'
                    : 'Email no verificado',
                child: Icon(
                  user!.emailVerified
                      ? Icons.verified_outlined
                      : Icons.error_outlined,
                  color: user!.emailVerified
                      ? Theme.of(context).primaryColor
                      : null,
                ),
              ),
            ),
            ListTile(
              title: const Text('Recuperar contraseña'),
              leading: const Icon(Icons.lock),
              onTap: () => sendPasswordReset(
                FirebaseAuth.instance.currentUser!.email!,
                'Cerrando sesión...\nSe ha enviado un correo para restablecer su contraseña',
                goToLogin: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
