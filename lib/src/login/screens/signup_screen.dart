import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/screens/home_screen_layout.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/utils/theme.dart';
import 'package:gem_dubi/const/resource.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();
  final _phoneTextEditingController = TextEditingController(text: '+');
  final _instagramTextEditingController = TextEditingController();

  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loginController = ref.read(loginProviderRef);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      R.ASSETS_GEM_LOGO_PNG,
                      width: 40,
                      height: 40,
                      color: Colors.white,
                      // color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _firstNameTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      filled: false,
                      prefixIcon: const Icon(Icons.person),
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
                      if (value!.trim().isEmpty) {
                        return 'The field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _lastNameTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      filled: false,
                      prefixIcon: const Icon(Icons.person),
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
                      if (value!.trim().isEmpty) {
                        return 'The field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _emailTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: false,
                      prefixIcon: const Icon(Icons.email),
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
                      if (value!.trim().isEmpty) {
                        return 'The field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordTextEditingController,
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: false,
                      prefixIcon: const Icon(Icons.lock),
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
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                        dragStartBehavior: DragStartBehavior.down,
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 250),
                          firstCurve: Curves.easeInOutSine,
                          secondCurve: Curves.easeInOutSine,
                          alignment: Alignment.center,
                          layoutBuilder: (Widget topChild, _, Widget bottomChild, __) {
                            return Stack(
                              alignment: Alignment.center,
                              children: <Widget>[bottomChild, topChild],
                            );
                          },
                          firstChild: const Icon(
                            Icons.visibility,
                            size: 25.0,
                            semanticLabel: 'show password',
                          ),
                          secondChild: const Icon(
                            Icons.visibility_off,
                            size: 25.0,
                            semanticLabel: 'hide password',
                          ),
                          crossFadeState: !_passwordVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Required Field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _confirmPasswordTextEditingController,
                    obscureText: _confirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: false,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
                        dragStartBehavior: DragStartBehavior.down,
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 250),
                          firstCurve: Curves.easeInOutSine,
                          secondCurve: Curves.easeInOutSine,
                          alignment: Alignment.center,
                          layoutBuilder: (Widget topChild, _, Widget bottomChild, __) {
                            return Stack(
                              alignment: Alignment.center,
                              children: <Widget>[bottomChild, topChild],
                            );
                          },
                          firstChild: const Icon(
                            Icons.visibility,
                            size: 25.0,
                            semanticLabel: 'show password',
                          ),
                          secondChild: const Icon(
                            Icons.visibility_off,
                            size: 25.0,
                            semanticLabel: 'hide password',
                          ),
                          crossFadeState: !_confirmPasswordVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        ),
                      ),
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
                      if (value!.trim().isEmpty) {
                        return 'The field is required!';
                      }
                      if (value.trim() != _passwordTextEditingController.text.trim()) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _phoneTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Whatsapp',
                      filled: false,
                      prefixIcon: const Icon(Icons.phone),
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
                      if (value!.trim().isEmpty) {
                        return 'The field is required';
                      }
                      if (value.trim().startsWith('+') && value.trim().length == 1) {
                        return 'must be +{countryCode}{number}';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _instagramTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Instagram',
                      hintText: '@userId',
                      filled: false,
                      prefixIcon: const Icon(Icons.account_circle),
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
                      if (value!.trim().isEmpty) {
                        return 'The field is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                var isSignUp = await loginController.signup(
                                  email: _emailTextEditingController.text,
                                  password: _passwordTextEditingController.text,
                                  firstName: _firstNameTextEditingController.text,
                                  lastName: _lastNameTextEditingController.text,
                                  phone: _phoneTextEditingController.text,
                                  instagram: _instagramTextEditingController.text,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                if (isSignUp == null) {
                                  router.replaceAllWith(const HomeScreenLayout());
                                } else {
                                  showSnackMessage(title: 'Error', text: isSignUp, icon: Icons.info, seconds: 2);
                                }
                              },
                              child: const Text(
                                'SUBMIT',
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
