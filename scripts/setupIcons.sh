#!/bin/bash

flutter pub get
flutter pub run flutter_launcher_icons:main
#flutter pub run flutter_launcher_name:main
flutter pub run flutter_native_splash:create
flutter pub run package_rename:set


echo Press enter to close the terminal;
read enter;
