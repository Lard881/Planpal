/// Status messages and error formatters for sync engine
class SyncMessages {
  SyncMessages._();

  static const String discardWarning =
      'Are you sure you want to discard this change? This cannot be undone.';
  static const String syncInProgress = 'Sync in progress...';
  static const String syncFailed = 'Sync failed';
  static const String itemsWaitingToSync = 'Items waiting to sync';
  static const String syncComplete = 'All changes synced';

  static String getErrorMessage(
    String entityType,
    String operation,
    String? lastError,
  ) {
    if (lastError != null && lastError.isNotEmpty) {
      return 'Failed to $operation $entityType: $lastError';
    }
    return 'Failed to $operation $entityType';
  }
}
