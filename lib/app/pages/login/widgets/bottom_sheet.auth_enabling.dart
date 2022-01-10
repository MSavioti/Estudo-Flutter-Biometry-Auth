import 'package:estudo_fingerprint/app/shared/utils_shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthEnablingBottomSheet extends StatelessWidget {
  const AuthEnablingBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    void _close() {
      Navigator.pop(context);
    }

    Future<void> _setHasDisabledAuth(bool set) async {
      final _sharedPreferences = UtilsSharedPreferences.instance;
      _sharedPreferences.saveBool('hasDisabledAuth', set);
      _sharedPreferences.saveBool('askedPermission', true);
    }

    return SafeArea(
      child: Container(
        height: _screenSize.height * 0.25,
        width: _screenSize.width,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6.0),
        child: Column(
          children: [
            const Text(
                'Do you wish to enable fingerprint authentication for future access?'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _setHasDisabledAuth(false);
                    _close();
                  },
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _setHasDisabledAuth(true);
                    _close();
                  },
                  child: const Text('Never'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
