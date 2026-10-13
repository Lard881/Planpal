import 'package:flutter/material.dart';
class TeamScreen extends StatelessWidget {
  final String? workspaceId;
  final bool showInvites;
  const TeamScreen({super.key, this.workspaceId, this.showInvites = false});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Team — Stage 15')));
}
