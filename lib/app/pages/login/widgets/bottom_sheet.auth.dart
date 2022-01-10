import 'package:estudo_fingerprint/app/shared/utils_biometry.dart';
import 'package:flutter/material.dart';

class AuthBottomSheet extends StatelessWidget {
  final Function() onAuthSuccess;
  final Function() onAuthFailed;

  const AuthBottomSheet({
    required this.onAuthSuccess,
    required this.onAuthFailed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    void _close() {
      Navigator.pop(context);
    }

    Future<void> _authenticate() async {
      bool _authenticated = false;

      try {
        _authenticated = await UtilsBiometry.instance.authenticate();
      } catch (e) {
        onAuthFailed();
      }

      if (_authenticated) {
        onAuthSuccess();
      } else {
        onAuthFailed();
      }
    }

    return SafeArea(
      child: Container(
        height: _screenSize.height * 0.25,
        width: _screenSize.width,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Login using your fingerprint:'),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  const Size(64.0, 48.0),
                ),
              ),
              onPressed: () async {
                await _authenticate();
              },
              child: const Icon(
                Icons.fingerprint,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                onPressed: () async {
                  _close();
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
