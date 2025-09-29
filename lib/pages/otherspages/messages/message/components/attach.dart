import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Attach extends StatefulWidget {
  const Attach({super.key});

  @override
  State<Attach> createState() => _AttachState();
}

class _AttachState extends State<Attach> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.attach_file, color: Colors.grey),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Wrap(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.insert_drive_file, color: Colors.blue),
                  title: const Text("Document"),
                  onTap: () async {
                    Navigator.pop(context);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
                    );
                    if (result != null) {
                      print("Document choisi : ${result.files.single.path}");
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image, color: Colors.green),
                  title: const Text("Image"),
                  onTap: () async {
                    Navigator.pop(context);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) {
                      print("Image choisie : ${result.files.single.path}");
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.audiotrack, color: Colors.purple),
                  title: const Text("Audio"),
                  onTap: () async {
                    Navigator.pop(context);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.audio,
                    );
                    if (result != null) {
                      print("Audio choisi : ${result.files.single.path}");
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.videocam, color: Colors.red),
                  title: const Text("Vidéo"),
                  onTap: () async {
                    Navigator.pop(context);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.video,
                    );
                    if (result != null) {
                      print("Vidéo choisie : ${result.files.single.path}");
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.folder, color: Colors.orange),
                  title: const Text("Autre"),
                  onTap: () async {
                    Navigator.pop(context);
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result != null) {
                      print("Fichier choisi : ${result.files.single.path}");
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
