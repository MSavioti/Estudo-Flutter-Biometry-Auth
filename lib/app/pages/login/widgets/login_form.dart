import 'package:estudo_fingerprint/app/pages/home/home_page.dart';
import 'package:estudo_fingerprint/app/pages/login/widgets/bottom_sheet.auth.dart';
import 'package:estudo_fingerprint/app/pages/login/widgets/bottom_sheet.auth_enabling.dart';
import 'package:estudo_fingerprint/app/shared/utils_shared_preferences.dart';
import 'package:estudo_fingerprint/app/shared/utils_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:estudo_fingerprint/app/pages/login/widgets/custom_icon_button.dart';
import 'package:estudo_fingerprint/app/pages/login/widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _isLoading;
  late bool _showPassword;
  late bool _canShowAuthMenu;
  late UtilsSharedPreferences _sharedPreferences;

  @override
  void initState() {
    _isLoading = false;
    _showPassword = false;
    _canShowAuthMenu = false;
    _sharedPreferences = UtilsSharedPreferences.instance;
    _fillFields();
    super.initState();
  }

  void _setEmail(String email) {
    _sharedPreferences.saveString('email', email);
  }

  void _setPassword(String password) {
    _sharedPreferences.saveString('password', password);
  }

  void _attemptLogin() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    print(_isValidEmail(_emailController.text));
    print(_isValidPassword(_passwordController.text));
    final _exists = await _loginExists();
    print(_exists);

    if ((_isValidEmail(_emailController.text)) &&
        (_isValidPassword(_passwordController.text)) &&
        (await _loginExists())) {
      await _login();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    return email.length > 6 && email.contains('@');
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  Future<bool> _loginExists() async {
    final _savedEmail = await _sharedPreferences.loadString('email');
    final _savedPassword = await _sharedPreferences.loadString('password');

    if ((_savedEmail.isEmpty) && (_savedPassword.isEmpty)) {
      return true;
    }

    return _emailController.text == _savedEmail &&
        _passwordController.text == _savedPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<void> _login() async {
    _setEmail(_emailController.text);
    _setPassword(_passwordController.text);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void _fillFields() async {
    final _savedEmail = await _sharedPreferences.loadString('email');
    final _savedPassword = await _sharedPreferences.loadString('password');

    _emailController.text = _savedEmail;
    _passwordController.text = _savedPassword;

    if ((_savedEmail.isNotEmpty) && (_savedPassword.isNotEmpty)) {
      final _hasDisabledAuth =
          await _sharedPreferences.loadBool('hasDisabledAuth');

      if (!_hasDisabledAuth) {
        final _askedPermission =
            await _sharedPreferences.loadBool('askedPermission');

        if (_askedPermission) {
          _showAuthMenu();
        } else {
          _askForAuthPermission();
        }
      }
    }
  }

  void _askForAuthPermission() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return const AuthEnablingBottomSheet();
      },
    );
  }

  void _showAuthMenu() async {
    showBottomSheet(
      context: context,
      builder: (context) {
        return AuthBottomSheet(
          onAuthSuccess: _login,
          onAuthFailed: () {},
        );
      },
    );
  }

  // SnackBarDefault.buildSnackBar(
  //           context: context,
  //           content: 'Error authenticating with fingerprint',
  //         ),

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(32.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 16.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomTextField(
                  controller: _emailController,
                  hint: 'E-mail',
                  prefix: const Icon(Icons.account_circle),
                  textInputType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hint: 'Senha',
                  textInputType: TextInputType.visiblePassword,
                  prefix: const Icon(Icons.lock),
                  obscure: !_showPassword,
                  enabled: !_isLoading,
                  suffix: CustomIconButton(
                    radius: 32.0,
                    iconData:
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                    onTap: _togglePasswordVisibility,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () async {
                      _attemptLogin();
                    },
                    child: _isLoading
                        ? const SizedBox(
                            height: 16.0,
                            width: 16.0,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
