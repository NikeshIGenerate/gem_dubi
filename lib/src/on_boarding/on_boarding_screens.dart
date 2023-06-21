import 'package:flutter/material.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/const/resource.dart';
import 'package:gem_dubi/src/login/screens/login_screen.dart';

import 'on_boarding_repository.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  void next() {
    OnBoardingRepository.instance.setFirstLoad();
    router.pushReplacement(const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
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
                        SizedBox(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'GEM is a private community that offers a variety of previlidged access to dining venues, exclusive events and sophisticated activties for social elites',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        fontSize: 15,
                                        color: Colors.white,
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  IconButton(
                    splashColor: Colors.white,
                    onPressed: next,
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
