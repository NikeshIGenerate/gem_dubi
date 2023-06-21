import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/utils/theme.dart';
import 'package:gem_dubi/const/resource.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/screens/reset_password_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginController = ref.read(loginProviderRef);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          R.ASSETS_LOGO_LOGO_PNG,
                          width: 180,
                          height: 180,
                          color: Colors.white,
                          // color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'GEM',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The field is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      const Text('We will send a password recovery code to your email'),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    try {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await loginController.resetPassword(_emailTextEditingController.text.trim());
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      showSnackMessage(title: 'Success', text: 'An email has been sent', icon: Icons.check, color: Colors.green, seconds: 2);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const ResetPasswordScreen(),
                                          settings: RouteSettings(arguments: {'email': _emailTextEditingController.text.trim()}),
                                        ),
                                      );
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      print(e);
                                      showSnackMessage(title: 'Error', text: 'Account doesn\'t exists', icon: Icons.info, seconds: 2);
                                    }
                                  },
                                  child: const Text(
                                    'RECOVER',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackMessage({required String title, required String text, required IconData icon, Color color = Colors.red, int seconds = 3}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: themeData.textTheme.labelLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
        backgroundColor: color,
      ),
    );
  }
}
