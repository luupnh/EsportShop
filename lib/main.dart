import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EsportShop/Counters/ItemQuantity.dart';
import 'package:EsportShop/Counters/bankcardchanger.dart';
import 'package:EsportShop/Counters/userchanger.dart';
import 'package:EsportShop/Store/storehomedefault.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:EsportShop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c)=> UserChanger()),
      ChangeNotifierProvider(create: (c)=> CartItemCounter()),
      ChangeNotifierProvider(create: (c)=> ItemQuantity()),
      ChangeNotifierProvider(create: (c)=> BankCardChanger()),
      ChangeNotifierProvider(create: (c)=> AddressChanger()),
      ChangeNotifierProvider(create: (c)=> TotalAmount()),
    ],
      child: MaterialApp(
          title: 'Esport-Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState() {
      displaySplash();
      super.initState();
  }
  displaySplash(){
    Timer(Duration(seconds: 1), ()async{
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,["garbageValue"] );
      if(await EcommerceApp.auth.currentUser()!=null){
        Route route = MaterialPageRoute(builder: (_)=>StoreHome());
        Navigator.pushReplacement(context, route);
      }else{
        Route route = MaterialPageRoute(builder: (_)=>StoreHomeDefault());
        Navigator.pushReplacement(context, route);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.teal,Colors.cyan],
           begin: const FractionalOffset(0.0, 0.0),
          end:  const FractionalOffset(1.0, 0.0),
          stops: [0.0,1.0],
          tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/welcome.png"),
            SizedBox(height: 20.0,),
          ],
        ),
        ),
      ),
    );
  }
}
