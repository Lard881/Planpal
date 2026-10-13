import 'package:flutter/material.dart';
class DocumentsScreen extends StatelessWidget {
  final String? documentId;
  const DocumentsScreen({super.key, this.documentId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Documents — Stage 9')));
}
