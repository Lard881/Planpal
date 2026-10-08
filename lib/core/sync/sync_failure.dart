import '../errors/app_failure.dart';

/// Sync failure types
enum SyncFailureType {
  /// Temporary network issue - will retry automatically
  temporary,
  
  /// Permanent failure requiring user action
  permanent,
}

/// Sync failure with user-friendly messages
class SyncFailure {
  final SyncFailureType type;
  final String message;
  final String? technicalDetails;
  final String? actionHint;
  
  const SyncFailure({
    required this.type,
    required this.message,
    this.technicalDetails,
    this.actionHint,
  });

  /// Create from an AppFailure
  factory SyncFailure.fromAppFailure(AppFailure failure) {
    return SyncFailure(
      type: _classifyFailure(failure),
      message: _getUserMessage(failure),
      technicalDetails: failure.toString(),
      actionHint: _getActionHint(failure),
    );
  }

  /// Create from a generic exception
  factory SyncFailure.fromException(Object error) {
    final isTemporary = _isTemporaryError(error);
    
    return SyncFailure(
      type: isTemporary ? SyncFailureType.temporary : SyncFailureType.permanent,
      message: isTemporary
          ? 'Connection issue. Will retry automatically.'
          : 'Sync failed. Please check the details.',
      technicalDetails: error.toString(),
      actionHint: isTemporary
          ? 'Check your internet connection'
          : 'You may need to discard this change or try again later',
    );
  }

  /// Classify if a failure is temporary or permanent
  static SyncFailureType _classifyFailure(AppFailure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return SyncFailureType.temporary;
      
      case TimeoutFailure:
        return SyncFailureType.temporary;
      
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        // 5xx errors are temporary, 4xx are permanent
        return serverFailure.statusCode >= 500
            ? SyncFailureType.temporary
            : SyncFailureType.permanent;
      
      case ValidationFailure:
        return SyncFailureType.permanent;
      
      case AuthFailure:
        return SyncFailureType.permanent;
      
      case PermissionFailure:
        return SyncFailureType.permanent;
      
      default:
        return SyncFailureType.permanent;
    }
  }

  /// Get user-friendly message
  static String _getUserMessage(AppFailure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Changes will sync when back online.';
    }
    
    if (failure is TimeoutFailure) {
      return 'Server is taking too long to respond. Will retry automatically.';
    }
    
    if (failure is ServerFailure) {
      if (failure.statusCode >= 500) {
        return 'Server error. Will retry automatically.';
      }
      return failure.message;
    }
    
    if (failure is ValidationFailure) {
      return 'Invalid data: ${failure.message}';
    }
    
    if (failure is AuthFailure) {
      return 'Authentication failed. Please sign in again.';
    }
    
    if (failure is PermissionFailure) {
      return 'You don\'t have permission to make this change.';
    }
    
    return failure.message;
  }

  /// Get action hint for user
  static String? _getActionHint(AppFailure failure) {
    if (failure is NetworkFailure) {
      return 'Check your internet connection';
    }
    
    if (failure is TimeoutFailure) {
      return 'The server might be slow or down. We\'ll keep trying.';
    }
    
    if (failure is ServerFailure && failure.statusCode >= 500) {
      return 'This is a server issue. We\'ll retry automatically.';
    }
    
    if (failure is ValidationFailure) {
      return 'You may need to fix the data and try again';
    }
    
    if (failure is AuthFailure) {
      return 'Tap here to sign in again';
    }
    
    if (failure is PermissionFailure) {
      return 'Contact a workspace admin for help';
    }
    
    return 'You can retry or discard this change';
  }

  /// Check if an error is temporary
  static bool _isTemporaryError(Object error) {
    final errorString = error.toString().toLowerCase();
    
    // Network-related errors
    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('unreachable')) {
      return true;
    }
    
    // Server errors (5xx)
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504')) {
      return true;
    }
    
    return false;
  }

  bool get isTemporary => type == SyncFailureType.temporary;
  bool get isPermanent => type == SyncFailureType.permanent;

  @override
  String toString() => message;
}

/// Sync status for entities
enum SyncStatus {
  /// Successfully synced with server
  synced,
  
  /// Waiting to be synced
  pending,
  
  /// Currently syncing
  syncing,
  
  /// Failed temporarily (will retry)
  failedTemporary,
  
  /// Failed permanently (needs user action)
  failedPermanent,
}

extension SyncStatusExtension on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.pending:
        return 'Waiting to sync';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.failedTemporary:
        return 'Sync failed (retrying)';
      case SyncStatus.failedPermanent:
        return 'Sync failed';
    }
  }

  bool get isError => this == SyncStatus.failedTemporary || 
                      this == SyncStatus.failedPermanent;
  
  bool get needsUserAction => this == SyncStatus.failedPermanent;
}

/// Friendly messages for common sync scenarios
class SyncMessages {
  static const String noInternet = 
      'No internet connection. Changes will sync when back online.';
  
  static const String serverDown = 
      'Server is temporarily down. We\'ll keep trying automatically.';
  
  static const String itemsWaitingToSync = 
      'items waiting to sync';
  
  static const String syncInProgress = 
      'Syncing your changes...';
  
  static const String syncComplete = 
      'All changes synced!';
  
  static const String syncFailed = 
      'Some changes couldn\'t be synced';
  
  static const String invalidData = 
      'This change has invalid data and can\'t be synced.';
  
  static const String permissionDenied = 
      'You don\'t have permission to make this change.';
  
  static const String conflictDetected = 
      'This item was changed elsewhere. Your changes were overwritten.';
  
  static const String lastAdminProtection = 
      'Cannot remove the last admin. Promote another member first.';
  
  static const String workspaceNotFound = 
      'This workspace no longer exists.';
  
  static const String retryHint = 
      'Tap to retry or discard';
  
  static const String discardWarning = 
      'This will permanently discard your changes. Continue?';

  /// Get a friendly message for an outbox item error
  static String getErrorMessage(String entityType, String operation, String? error) {
    if (error == null) return 'Unknown error';

    final errorLower = error.toLowerCase();

    // Network errors
    if (errorLower.contains('network') || 
        errorLower.contains('connection') ||
        errorLower.contains('socket')) {
      return noInternet;
    }

    // Server errors
    if (errorLower.contains('500') || 
        errorLower.contains('503') ||
        errorLower.contains('server')) {
      return serverDown;
    }

    // Permission errors
    if (errorLower.contains('permission') || 
        errorLower.contains('forbidden') ||
        errorLower.contains('403')) {
      return permissionDenied;
    }

    // Validation errors
    if (errorLower.contains('validation') || 
        errorLower.contains('invalid')) {
      return invalidData;
    }

    // Not found errors
    if (errorLower.contains('not found') || 
        errorLower.contains('404')) {
      return '$entityType not found. It may have been deleted.';
    }

    // Last admin protection
    if (errorLower.contains('last admin')) {
      return lastAdminProtection;
    }

    // Generic message
    return 'Failed to $operation $entityType: ${error.substring(0, error.length > 50 ? 50 : error.length)}';
  }
}
