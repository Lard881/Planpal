import 'package:flutter/material.dart';
class ChatScreen extends StatelessWidget {
  final String? channelId;
  const ChatScreen({super.key, this.channelId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Chat — Stage 10')));
}
