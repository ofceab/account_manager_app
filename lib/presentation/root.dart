import 'package:flutter/material.dart';

//Own importation
import 'screens/screen_manager.dart';

class AccountManagerApp extends StatelessWidget{

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenManager(),
    );
  }
}