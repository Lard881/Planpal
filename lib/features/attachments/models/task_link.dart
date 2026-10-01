import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_link.freezed.dart';
part 'task_link.g.dart';

/// Task link model
/// Represents a URL/link attachment to a task
@freezed
class TaskLink with _$TaskLink {
  const factory TaskLink({
    required String id,
    required String taskId,
    required String workspaceId,
    required String addedBy,
    required String url,
    String? title,
    String? description,
    String? faviconUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _TaskLink;

  factory TaskLink.fromJson(Map<String, dynamic> json) =>
      _$TaskLinkFromJson(json);
}

/// Extension for task link helper methods
extension TaskLinkX on TaskLink {
  /// Get domain from URL
  String? get domain {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (e) {
      return null;
    }
  }

  /// Get protocol (http/https)
  String? get protocol {
    try {
      final uri = Uri.parse(url);
      return uri.scheme;
    } catch (e) {
      return null;
    }
  }

  /// Check if URL is secure (HTTPS)
  bool get isSecure {
    return protocol == 'https';
  }

  /// Get display title (fallback to domain if title is null)
  String get displayTitle {
    if (title != null && title!.isNotEmpty) {
      return title!;
    }
    return domain ?? 'Link';
  }

  /// Get truncated title for display
  String getTruncatedTitle({int maxLength = 50}) {
    final displayText = displayTitle;
    if (displayText.length <= maxLength) {
      return displayText;
    }
    return '${displayText.substring(0, maxLength - 3)}...';
  }

  /// Get truncated URL for display
  String getTruncatedUrl({int maxLength = 60}) {
    if (url.length <= maxLength) {
      return url;
    }
    return '${url.substring(0, maxLength - 3)}...';
  }

  /// Check if link has metadata
  bool get hasMetadata {
    return title != null || description != null || faviconUrl != null;
  }

  /// Get link type based on domain
  LinkType get linkType {
    final domainLower = domain?.toLowerCase() ?? '';

    if (domainLower.contains('github.com')) return LinkType.github;
    if (domainLower.contains('gitlab.com')) return LinkType.gitlab;
    if (domainLower.contains('figma.com')) return LinkType.figma;
    if (domainLower.contains('google.com') || domainLower.contains('docs.google')) {
      return LinkType.googleDocs;
    }
    if (domainLower.contains('notion.so')) return LinkType.notion;
    if (domainLower.contains('slack.com')) return LinkType.slack;
    if (domainLower.contains('trello.com')) return LinkType.trello;
    if (domainLower.contains('jira.')) return LinkType.jira;
    if (domainLower.contains('confluence.')) return LinkType.confluence;
    if (domainLower.contains('youtube.com') || domainLower.contains('youtu.be')) {
      return LinkType.youtube;
    }
    if (domainLower.contains('drive.google')) return LinkType.googleDrive;
    if (domainLower.contains('dropbox.com')) return LinkType.dropbox;

    return LinkType.other;
  }

  /// Get icon for link type
  String get linkTypeIcon {
    switch (linkType) {
      case LinkType.github:
        return '💻';
      case LinkType.gitlab:
        return '🦊';
      case LinkType.figma:
        return '🎨';
      case LinkType.googleDocs:
        return '📝';
      case LinkType.notion:
        return '📔';
      case LinkType.slack:
        return '💬';
      case LinkType.trello:
        return '📋';
      case LinkType.jira:
        return '🔷';
      case LinkType.confluence:
        return '📚';
      case LinkType.youtube:
        return '🎥';
      case LinkType.googleDrive:
        return '📁';
      case LinkType.dropbox:
        return '📦';
      case LinkType.other:
        return '🔗';
    }
  }

  /// Check if URL can be opened in app (vs external browser)
  bool get canOpenInApp {
    // Most links should open in external browser
    // Only specific types might have in-app handlers
    return false;
  }

  /// Get fallback favicon URL using Google's favicon service
  String get fallbackFaviconUrl {
    if (domain != null) {
      return 'https://www.google.com/s2/favicons?domain=$domain&sz=32';
    }
    return '';
  }

  /// Get best favicon URL (custom or fallback)
  String get bestFaviconUrl {
    if (faviconUrl != null && faviconUrl!.isNotEmpty) {
      return faviconUrl!;
    }
    return fallbackFaviconUrl;
  }
}

/// Link type enum for categorization
enum LinkType {
  github,
  gitlab,
  figma,
  googleDocs,
  notion,
  slack,
  trello,
  jira,
  confluence,
  youtube,
  googleDrive,
  dropbox,
  other;

  String get displayName {
    switch (this) {
      case LinkType.github:
        return 'GitHub';
      case LinkType.gitlab:
        return 'GitLab';
      case LinkType.figma:
        return 'Figma';
      case LinkType.googleDocs:
        return 'Google Docs';
      case LinkType.notion:
        return 'Notion';
      case LinkType.slack:
        return 'Slack';
      case LinkType.trello:
        return 'Trello';
      case LinkType.jira:
        return 'Jira';
      case LinkType.confluence:
        return 'Confluence';
      case LinkType.youtube:
        return 'YouTube';
      case LinkType.googleDrive:
        return 'Google Drive';
      case LinkType.dropbox:
        return 'Dropbox';
      case LinkType.other:
        return 'Link';
    }
  }
}

/// Link metadata for fetching from URLs
@freezed
class LinkMetadata with _$LinkMetadata {
  const factory LinkMetadata({
    required String url,
    String? title,
    String? description,
    String? faviconUrl,
    String? domain,
    String? imageUrl,
  }) = _LinkMetadata;

  factory LinkMetadata.fromJson(Map<String, dynamic> json) =>
      _$LinkMetadataFromJson(json);
}
