// import 'dart:async';
// import 'package:flutter/material.dart';

// class ButtonContact extends StatefulWidget {
//   const ButtonContact({super.key});

//   @override
//   State<ButtonContact> createState() => _ButtonContactState();
// }

// class _ButtonContactState extends State<ButtonContact> {
//   bool isPressed = false;
//   Timer? _timer;
//   int seconds = 0;

//   // Lance le chronomètre
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() => seconds++);
//     });
//   }

//   // Stoppe et réinitialise le chronomètre
//   void _stopTimer() {
//     _timer?.cancel();
//     seconds = 0;
//   }

//   // Formate le temps en mm:ss
//   String get _formattedTime {
//     final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
//     final secs = (seconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$secs';
//   }

//   void _toggleRecording() {
//     setState(() {
//       isPressed = !isPressed;
//       if (isPressed) {
//         _startTimer();
//       } else {
//         _stopTimer();
//       }
//     });
//   }

//   Widget _buildRecordingWidget() {
//     return Container(
//       key: const ValueKey('recording'),
//       padding: const EdgeInsets.only(bottom: 15, top: 15),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         border: Border.all(
//           color: Colors.orange,
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       width: 80,
//       height: 120,
//       child: Column(
//         children: [
//           IconButton(
//             onPressed: _toggleRecording,
//             icon: const Icon(
//               Icons.send,
//               color: Colors.orange,
//             ),
//           ),
//           const Spacer(),
//           const SizedBox(height: 4),
//           Text(
//             _formattedTime,
//             style: const TextStyle(fontSize: 12, color: Colors.black),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNormalButton() {
//     return Container(
//       key: const ValueKey('normal'),
//       decoration: BoxDecoration(
//         color: Colors.orange,
//         border: Border.all(color: Colors.white),
//         shape: BoxShape.circle,
//       ),
//       width: 80,
//       height: 80,
//       child: const Center(
//         child: Icon(
//           Icons.mic,
//           color: Colors.white,
//           size: 36,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Center(
//         child: GestureDetector(
//           onTap: _toggleRecording,
//           child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             transitionBuilder: (child, animation) =>
//                 ScaleTransition(scale: animation, child: child),
//             child: isPressed ? _buildRecordingWidget() : _buildNormalButton(),
//           ),
//         ),
//       ),
//     );
//   }
// }
