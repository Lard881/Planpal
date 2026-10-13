// app/lib/core/widgets/avatar.dart
// Circle avatar with photo or deterministic initials. Optional presence dot.
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class Avatar extends StatelessWidget {
  final String userId;
  final String name;
  final String? avatarUrl;
  final double size;
  final PresenceStatus? presence;

  const Avatar({
    super.key,
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.size = 36,
    this.presence,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final initials = _initials(name);
    final color = avatarColorFor(userId);

    Widget avatar;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      avatar = CachedNetworkImage(
        imageUrl: avatarUrl!,
        imageBuilder: (ctx, img) => Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: img, fit: BoxFit.cover),
          ),
        ),
        placeholder: (_, __) => _initialsCircle(color, initials, c),
        errorWidget: (_, __, ___) => _initialsCircle(color, initials, c),
      );
    } else {
      avatar = _initialsCircle(color, initials, c);
    }

    if (presence == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: -1, right: -1,
          child: _PresenceDot(status: presence!, borderColor: c.surface),
        ),
      ],
    );
  }

  Widget _initialsCircle(Color bg, String initials, PlanPalColors c) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: Text(initials,
          style: AppText.bodyStrong.copyWith(
            color: Colors.white,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// Gradient avatar used for the current user in sidebar and mobile header
class CurrentUserAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double size;

  const CurrentUserAvatar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final initials = Avatar._initials(name);

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: avatarUrl!,
        imageBuilder: (_, img) => Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: img, fit: BoxFit.cover),
          ),
        ),
        placeholder: (_, __) => _gradientCircle(c, initials),
        errorWidget: (_, __, ___) => _gradientCircle(c, initials),
      );
    }
    return _gradientCircle(c, initials);
  }

  Widget _gradientCircle(PlanPalColors c, String initials) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [c.primary, c.violet],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(initials,
          style: AppText.bodyStrong.copyWith(
            color: Colors.white,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }
}

enum PresenceStatus { online, away, offline }

class _PresenceDot extends StatelessWidget {
  final PresenceStatus status;
  final Color borderColor;
  const _PresenceDot({required this.status, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = switch (status) {
      PresenceStatus.online => c.success,
      PresenceStatus.away => c.warning,
      PresenceStatus.offline => c.presenceOffline,
    };
    return Container(
      width: 12, height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
    );
  }
}
