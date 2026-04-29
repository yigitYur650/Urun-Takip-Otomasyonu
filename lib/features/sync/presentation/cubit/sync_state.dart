sealed class SyncState {
  const SyncState();
}

class SyncInitial extends SyncState {
  const SyncInitial();
}

class SyncInProgress extends SyncState {
  const SyncInProgress();
}

class SyncSuccess extends SyncState {
  final String message;
  const SyncSuccess(this.message);
}

class SyncError extends SyncState {
  final String message;
  const SyncError(this.message);
}

class SyncAuthState extends SyncState {
  final bool isSignedIn;
  const SyncAuthState(this.isSignedIn);
}
