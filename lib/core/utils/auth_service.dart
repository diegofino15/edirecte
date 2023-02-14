import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';

import 'package:edirecte/core/utils/logger.dart';

class AuthService {
  static Future<bool> authenticateUser() async {
    // Initialize Local Authentication plugin.
    final LocalAuthentication localAuthentication = LocalAuthentication();
    // Status of authentication.
    bool isAuthenticated = false;
    // Check if device supports biometrics authentication.
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    // Check if user has enabled biometrics.
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    // If device supports biometrics and user has enabled biometrics, then authenticate.
    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Identifiez vous pour voir le mot de passe',
          options: const AuthenticationOptions(
            biometricOnly: false,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } on PlatformException catch (e) {
        Logger.printMessage("An error occured when authenticating");
        Logger.printMessage("Error : $e");
      }
    }
    return isAuthenticated;
  }
}
