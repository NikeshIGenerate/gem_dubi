import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingRepository {
  static final OnBoardingRepository instance = _OnBoardingRepositoryImpl();

  /// is this is first time launch
  Future<bool> firstLoad();

  Future<void> setFirstLoad([bool loaded = true]);
}

class _OnBoardingRepositoryImpl implements OnBoardingRepository {
  @override
  Future<bool> firstLoad() async {
    final shared = await SharedPreferences.getInstance();

    return shared.getBool('OnBoarding.first_load') ?? true;
  }

  @override
  Future<void> setFirstLoad([bool loaded = false]) async {
    final shared = await SharedPreferences.getInstance();

    await shared.setBool('OnBoarding.first_load', loaded);
  }
}
