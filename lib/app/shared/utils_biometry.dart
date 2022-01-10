import 'package:local_auth/local_auth.dart';

class UtilsBiometry {
  late bool canCheckBiometrics;
  late bool isFingerprintAvailable;
  late LocalAuthentication _auth;

  static final UtilsBiometry _instance = UtilsBiometry._();

  static UtilsBiometry get instance => _instance;

  UtilsBiometry._() {
    _auth = LocalAuthentication();
    // _checkPermissions();
  }

  Future<bool> authenticate() async {
    bool _authenticated = false;

    try {
      final _isDeviceSupported = await _auth.isDeviceSupported();

      if (_isDeviceSupported) {
        _auth.authenticate(
          localizedReason: 'Authenticate to save your login',
          biometricOnly: true,
          stickyAuth: true,
        );
      }

      return _authenticated;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // void _checkPermissions() async {
  //   canCheckBiometrics = await _auth.canCheckBiometrics;

  //   List<BiometricType> availableBiometrics =
  //       await _auth.getAvailableBiometrics();

  //   if (availableBiometrics.contains(BiometricType.fingerprint)) {
  //     // Touch ID.
  //   }
  // }
}
