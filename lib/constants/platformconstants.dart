
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // for iOS platform etc. 


// THEME Settings 
// iOS
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

// Android or the default
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

// Assign the correct theme, based on the platform

final bool isIOS = (defaultTargetPlatform == TargetPlatform.iOS) ? true : false;

final platformTheme = isIOS ? kIOSTheme : kDefaultTheme;

// END of Theme settings