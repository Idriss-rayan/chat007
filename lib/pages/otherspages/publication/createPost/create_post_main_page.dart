import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simplechat/model/post_model.dart';
import 'package:simplechat/model/provider_model.dart';

class CreatePostMainPage extends StatefulWidget {
  const CreatePostMainPage({super.key});

  @override
  State<CreatePostMainPage> createState() => _CreatePostMainPageState();
}

class _CreatePostMainPageState extends State<CreatePostMainPage> {
  final TextEditingController _postController = TextEditingController();
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submitPost() {
    if (_postController.text.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post cannot be empty!")),
      );
      return;
    }

    final newPost = Post(
      text: _postController.text,
      image: _selectedImage != null ? File(_selectedImage!.path) : null,
    );

    Provider.of<PostProvider>(context, listen: false).addPost(newPost);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post created successfully!")),
    );

    _postController.clear();
    setState(() {
      _selectedImage = null;
    });

    Navigator.pop(context);
  }

  // --- 🔥 Affichage du premier BottomSheet (choix public/private) ---
  void _showDiscussionModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Start a Discussion",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Choose the type of discussion you want to start.",
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // --- Public Discussion ---
              _buildOptionCard(
                icon: Icons.public,
                title: "Public Discussion",
                subtitle: "Anyone can join and listen",
                color: Colors.deepOrangeAccent.shade100,
                onTap: () {
                  Navigator.pop(context);
                  Future.microtask(() => _showPublicDiscussionModal());
                },
              ),
              const SizedBox(height: 12),

              // --- Private Discussion ---
              _buildOptionCard(
                icon: Icons.lock,
                title: "Private Discussion",
                subtitle: "Only invited people can join",
                color: Colors.pinkAccent.shade100,
                onTap: () {
                  Navigator.pop(context);
                  Future.microtask(() => _showPrivateDiscussionModal());
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // --- Modal Public Discussion ---
  void _showPublicDiscussionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Controllers pour les champs
        final TextEditingController nameController = TextEditingController();
        double duration = 5; // durée par défaut (en minutes)
        double limit = 10; // nombre de participants par défaut

        return StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 600, minHeight: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Petit indicateur de drag
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "🎙️ Customize Discussion",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Champ Nom du Space
                  const Text(
                    "Space Name",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter the name of your space...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Durée par utilisateur
                  const Text(
                    "Duration per Speaker (minutes)",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Slider(
                          value: duration,
                          min: 1,
                          max: 30,
                          divisions: 29,
                          activeColor: Colors.deepOrange,
                          label: "${duration.toInt()} min",
                          onChanged: (val) => setState(() => duration = val),
                        ),
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${duration.toInt()}m",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Nombre limite de participants
                  const Text(
                    "Maximum Participants",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Slider(
                          value: limit,
                          min: 2,
                          max: 1000,
                          divisions: 98,
                          activeColor: Colors.deepOrange,
                          label: "${limit.toInt()} users",
                          onChanged: (val) => setState(() => limit = val),
                        ),
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${limit.toInt()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Bouton de validation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Tu pourras ici traiter les données:
                        // nameController.text, duration, limit
                      },
                      child: const Text(
                        "Start Discussion",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Modal Private Discussion ---
  void _showPrivateDiscussionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Private Discussion",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Construction des cartes de choix ---
  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        //width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // --- UI principale ---
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Post"),
        backgroundColor: Colors.deepOrangeAccent.shade100,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create your own post",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),

            // --- Zone de texte ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                controller: _postController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Write something...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Image sélectionnée ---
            if (_selectedImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(_selectedImage!.path),
                      width: size.width,
                      height: size.width * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // --- Boutons Image/Audio/Post ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.black54),
                  label: const Text("Add Image",
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Colors.deepOrange,
                      width: 1,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.audio_file, color: Colors.black54),
                  label: const Text("Add Audio",
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Colors.pink,
                      width: 1,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(126, 64, 195, 255),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Post",
                      style: TextStyle(color: Colors.black54)),
                ),
              ],
            ),
            const Divider(height: 40),

            // --- Section Start Discussion ---
            Text(
              "Create discussion stream audio",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(
                height:
                    16), ///////////////////////////////////====================////////////////////////
            Center(
              child: Image.asset(
                "assets/images/mic.png",
                width: 200,
                height: 200,
              ),
            ),
            Center(
              child: InkWell(
                onTap: _showDiscussionModal,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Colors.pinkAccent, Colors.orangeAccent],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
