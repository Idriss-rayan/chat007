// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:simplechat/pages/otherspages/messages/message/service_socket.dart';

// class SocketStatusWidget extends StatefulWidget {
//   const SocketStatusWidget({super.key});

//   @override
//   State<SocketStatusWidget> createState() => _SocketStatusWidgetState();
// }

// class _SocketStatusWidgetState extends State<SocketStatusWidget> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Connexion au serveur
//     final socketService = context.read<SocketService>();
//     socketService.connect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat Socket.IO')),
//       body: Consumer<SocketService>(
//         builder: (context, socketService, _) {
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: socketService.messages.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(socketService.messages[index]),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _controller,
//                         decoration: const InputDecoration(
//                           hintText: 'Écris un message...',
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send),
//                       onPressed: () {
//                         final message = _controller.text.trim();
//                         if (message.isNotEmpty) {
//                           socketService.sendMessage(message);
//                           _controller.clear();
//                         }
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
