import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Avatar component with image, initials fallback, and presence dot
class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final Color? backgroundColor;
  final bool showPresence;
  final PresenceStatus? presenceStatus;

  const Avatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.backgroundColor,
    this.showPresence = false,
    this.presenceStatus,
  });

  String _getInitials() {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;

    return Stack(
      children: [
        // Avatar circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        width: size * 0.5,
                        height: size * 0.5,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Text(
                        _getInitials(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size * 0.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    _getInitials(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),

        // Presence dot
        if (showPresence && presenceStatus != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: _getPresenceColor(presenceStatus!),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getPresenceColor(PresenceStatus status) {
    switch (status) {
      case PresenceStatus.online:
        return const Color(0xFF10B981);
      case PresenceStatus.away:
        return const Color(0xFFF59E0B);
      case PresenceStatus.offline:
        return const Color(0xFF64748B);
    }
  }
}

/// Presence status enum
enum PresenceStatus {
  online,
  away,
  offline,
}
