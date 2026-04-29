import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/result.dart';
import '../../domain/repositories/i_sync_repository.dart';
import 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  final ISyncRepository _syncRepository;
  bool _isSignedIn = false;

  SyncCubit({required ISyncRepository syncRepository})
      : _syncRepository = syncRepository,
        super(const SyncInitial()) {
    checkSignInStatus();
  }

  bool get isSignedIn => _isSignedIn;

  Future<void> checkSignInStatus() async {
    final result = await _syncRepository.isSignedIn();
    switch (result) {
      case Success(data: final signedIn):
        _isSignedIn = signedIn;
        emit(SyncAuthState(_isSignedIn));
      case Error():
        break;
    }
  }

  Future<void> signIn() async {
    emit(const SyncInProgress());
    final result = await _syncRepository.signIn();
    switch (result) {
      case Success():
        _isSignedIn = true;
        emit(SyncAuthState(true));
      case Error(failure: final failure):
        emit(SyncError(failure.message));
        emit(SyncAuthState(false));
    }
  }

  Future<void> signOut() async {
    emit(const SyncInProgress());
    final result = await _syncRepository.signOut();
    switch (result) {
      case Success():
        _isSignedIn = false;
        emit(SyncAuthState(false));
      case Error(failure: final failure):
        emit(SyncError(failure.message));
        emit(SyncAuthState(_isSignedIn));
    }
  }

  Future<void> backup() async {
    if (!_isSignedIn) {
      await signIn();
      if (!_isSignedIn) return;
    }

    emit(const SyncInProgress());
    final result = await _syncRepository.backup();
    switch (result) {
      case Success():
        emit(const SyncSuccess('Backup completed successfully!'));
        emit(SyncAuthState(_isSignedIn));
      case Error(failure: final failure):
        emit(SyncError(failure.message));
        emit(SyncAuthState(_isSignedIn));
    }
  }

  Future<void> restore() async {
    if (!_isSignedIn) {
      await signIn();
      if (!_isSignedIn) return;
    }

    emit(const SyncInProgress());
    final result = await _syncRepository.restore();
    switch (result) {
      case Success():
        emit(const SyncSuccess('Restore completed successfully! Restart the app to see changes.'));
        emit(SyncAuthState(_isSignedIn));
      case Error(failure: final failure):
        emit(SyncError(failure.message));
        emit(SyncAuthState(_isSignedIn));
    }
  }
}
