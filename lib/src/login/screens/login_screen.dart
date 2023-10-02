import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/common/screens/home_screen_layout.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/utils/theme.dart';
import 'package:gem_dubi/const/resource.dart';
import 'package:gem_dubi/src/chat/conversation_list_screen.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/screens/forgot_password_screen.dart';
import 'package:gem_dubi/src/login/screens/signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  var _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final loginController = ref.read(loginProviderRef);

    // return FlutterLogin(
    //   theme: LoginTheme(
    //     pageColorDark: Colors.black,
    //     pageColorLight: Colors.black,
    //   ),
    //   logo: R.ASSETS_LOGO_LOGO_PNG,
    //   additionalSignupFields: [
    //     UserFormField(
    //       keyName: 'first_name',
    //       displayName: 'First Name',
    //       userType: LoginUserType.name,
    //       fieldValidator: ValidationBuilder().required().build(),
    //     ),
    //     UserFormField(
    //       keyName: 'last_name',
    //       displayName: 'Last Name',
    //       userType: LoginUserType.name,
    //       fieldValidator: ValidationBuilder().required().build(),
    //     ),
    //     UserFormField(
    //       keyName: 'phone',
    //       displayName: 'Whatsapp',
    //       defaultValue: '+',
    //       userType: LoginUserType.phone,
    //       fieldValidator: (value) {
    //         try {
    //           final number = PhoneNumber.parse(value ?? '');
    //           return number.isValid() ? null : 'must be +{countryCode}{number}';
    //         } catch (e) {
    //           return 'must be +{countryCode}{number}';
    //         }
    //       },
    //     ),
    //     UserFormField(
    //       keyName: 'instagram',
    //       displayName: 'Instagram',
    //       userType: LoginUserType.email,
    //       fieldValidator: ValidationBuilder().required().build(),
    //     ),
    //   ],
    //   onSignup: (d) =>
    //       loginController.signup(
    //         email: d.name!,
    //         password: d.password!,
    //         firstName: d.additionalSignupData!['first_name']!,
    //         lastName: d.additionalSignupData!['last_name']!,
    //         phone: d.additionalSignupData!['phone']!,
    //         instagram: d.additionalSignupData!['instagram']!,
    //       ),
    //   onLogin: (loginDetails) =>
    //       loginController.login(
    //         loginDetails.name,
    //         loginDetails.password,
    //       ),
    //   onRecoverPassword: (passwordRecovery) async {
    //     try {
    //       await loginController.resetPassword(passwordRecovery);
    //     } catch (e) {
    //       return 'Cant send email to you';
    //     }
    //   },
    //   onConfirmRecover: (value, data) async {
    //     try {
    //       await loginController.updatePassword(
    //         email: data.name,
    //         newPassword: data.password,
    //         code: value,
    //       );
    //     } catch (e) {
    //       return 'Cant send email to you';
    //     }
    //   },
    //   onSubmitAnimationCompleted: () => router.replaceAllWith(const HomeScreenLayout()),
    // );

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: _formKey,
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
                        children: [
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
                              if (value!.isEmpty) {
                                return 'Required Field';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _passwordTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: false,
                              prefixIcon: const Icon(Icons.lock),
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
                            obscureText: _passwordVisible,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required Field';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              router.push(const ForgotPasswordScreen());
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
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
                                        if (!_formKey.currentState!.validate()) {
                                          return;
                                        }
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        var isLogin = await loginController.login(
                                          _emailTextEditingController.text,
                                          _passwordTextEditingController.text,
                                        );
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (isLogin == null) {
                                          if (_emailTextEditingController.text.trim() == kAdminEmail) {
                                            router.replaceAllWith(const ConversationListScreen());
                                          } else {
                                            router.replaceAllWith(const HomeScreenLayout());
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info,
                                                    color: Colors.white.withOpacity(0.5),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Error',
                                                          style: themeData.textTheme.labelLarge!.copyWith(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          isLogin,
                                                          style: const TextStyle(color: Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                              onPressed: !_isLoading
                                  ? () {
                                      router.push(const SignUpScreen());
                                    }
                                  : null,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
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
        ),
      ),
    );
  }
}
