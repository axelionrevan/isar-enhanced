
const _isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');

class DartUtils {
  static bool get isWasm => _isRunningWithWasm;

  static bool get isWeb => const bool.fromEnvironment('dart.library.html') || const bool.fromEnvironment('dart.library.js_util') || const bool.fromEnvironment('dart.library.js') || const bool.fromEnvironment('dart.library.js_interop') || isWasm;
}
