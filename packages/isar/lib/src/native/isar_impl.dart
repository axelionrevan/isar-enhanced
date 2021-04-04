part of isar_native;

const zoneTxn = #zoneTxn;
const zoneTxnWrite = #zoneTxnWrite;
const zoneTxnStream = #zoneTxnStream;

class IsarImpl extends Isar {
  final Pointer isarPtr;

  final List<Future> _activeAsyncTxns = [];
  Pointer? _currentTxnSync;
  bool _currentTxnSyncWrite = false;

  IsarImpl(String path, this.isarPtr) : super(path);

  void requireNotInTxn() {
    if (_currentTxnSync != null || Zone.current[zoneTxn] != null) {
      throw 'Cannot perform this operation from within an active transaction.';
    }
  }

  Future<T> _txn<T>(
      bool write, bool silent, Future<T> Function(Isar isar) callback) async {
    requireNotInTxn();

    final completer = Completer();
    _activeAsyncTxns.add(completer.future);

    final port = ReceivePort();
    final portStream = wrapIsarPort(port);

    final txnPtrPtr = malloc<Pointer<NativeType>>();
    IC.isar_txn_begin(
        isarPtr, txnPtrPtr, false, write, silent, port.sendPort.nativePort);

    Pointer<NativeType> txnPtr;
    try {
      await portStream.first;
      txnPtr = txnPtrPtr.value;
    } finally {
      malloc.free(txnPtrPtr);
    }

    final zone = Zone.current.fork(zoneValues: {
      zoneTxn: txnPtr,
      zoneTxnWrite: write,
      zoneTxnStream: portStream,
    });

    T result;
    try {
      result = await zone.run(() => callback(this));
    } catch (e) {
      IC.isar_txn_finish(txnPtr, false);
      port.close();
      completer.complete();
      _activeAsyncTxns.remove(completer.future);
      rethrow;
    }

    IC.isar_txn_finish(txnPtr, true);
    await portStream.first;

    port.close();
    completer.complete();
    _activeAsyncTxns.remove(completer.future);

    return result;
  }

  @override
  Future<T> txn<T>(Future<T> Function(Isar isar) callback) {
    return _txn(false, false, callback);
  }

  @override
  Future<T> writeTxn<T>(Future<T> Function(Isar isar) callback,
      {bool silent = false}) {
    return _txn(true, silent, callback);
  }

  Future<T> getTxn<T>(bool write,
      Future<T> Function(Pointer txn, Stream<Null> stream) callback) {
    final currentTxn = Zone.current[zoneTxn];
    if (currentTxn != null) {
      if (write && !Zone.current[zoneTxnWrite]) {
        throw 'Operation cannot be performed within a read transaction.';
      }
      return callback(currentTxn, Zone.current[zoneTxnStream]);
    } else if (!write) {
      return _txn(false, false, (isar) {
        return callback(Zone.current[zoneTxn], Zone.current[zoneTxnStream]);
      });
    } else {
      throw 'Write operations require an explicit transaction.';
    }
  }

  T _txnSync<T>(bool write, bool silent, T Function(Isar isar) callback) {
    requireNotInTxn();

    var txnPtr = IsarCoreUtils.syncTxnPtr;
    nCall(IC.isar_txn_begin(isarPtr, txnPtr, true, write, silent, 0));
    var txn = txnPtr.value;
    _currentTxnSync = txn;
    _currentTxnSyncWrite = write;

    T result;
    try {
      result = callback(this);
    } catch (e) {
      _currentTxnSync = null;
      IC.isar_txn_finish(txn, false);
      rethrow;
    }

    _currentTxnSync = null;
    nCall(IC.isar_txn_finish(txn, true));

    return result;
  }

  @override
  T txnSync<T>(T Function(Isar isar) callback) {
    return _txnSync(false, false, callback);
  }

  @override
  T writeTxnSync<T>(T Function(Isar isar) callback, {bool silent = false}) {
    return _txnSync(true, silent, callback);
  }

  T getTxnSync<T>(bool write, T Function(Pointer txn) callback) {
    if (_currentTxnSync != null) {
      if (write && !_currentTxnSyncWrite) {
        throw 'Operation cannot be performed within a read transaction.';
      }
      return callback(_currentTxnSync!);
    } else if (!write) {
      return _txnSync(false, false, (isar) => callback(_currentTxnSync!));
    } else {
      throw 'Write operations require an explicit transaction.';
    }
  }

  @override
  Future close() async {
    requireNotInTxn();
    await Future.wait(_activeAsyncTxns);
    await super.close();
    IC.isar_close_instance(isarPtr);
  }
}
