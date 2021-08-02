import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EsportShop/Admin/adminLogin.dart';
import 'package:EsportShop/Widgets/customTextField.dart';
import 'package:EsportShop/DialogBox/errorDialog.dart';
import 'package:EsportShop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Store/storehome.dart';
import 'package:EsportShop/Config/config.dart';
import 'package:google_sign_in/google_sign_in.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
{
  bool _isLogIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/login.png",
                height: 200.0,
                width: 200.0,),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("User",
                style: TextStyle(color: Colors.white,fontSize: 28.0,fontWeight: FontWeight.bold),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: (){
              loginUser();
              },
              color: Colors.white,
              child: Text("Sign up",style: TextStyle(color: Colors.black),),
            ),
            SizedBox(
              height: 50.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton.icon(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignInPage())),
              icon: (Icon(Icons.admin_panel_settings_rounded,color: Colors.white)),
              label: Text("Admin",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25),),

            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async
  {
    showDialog(
     context: context,
     builder: (c){
       return LoadingAlertDialog(message: "Authencating ,wait",);
     }
    );
    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
    ).then((authUser){
      firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: error.message.toString(),);
        }
      );
    });
    if(firebaseUser != null)
      {
        readData(firebaseUser).then((s){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c)=> StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }
  }
  void loginGG() async{
      await _googleSignIn.signIn();
      FirebaseUser firebaseUser;
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _googleSignIn.currentUser.displayName);
      Route route = MaterialPageRoute(builder: (c)=> StoreHome());
      Navigator.pushReplacement(context, route);
      setState(() {
        _isLogIn = true;
      });
  }
  Future readData(FirebaseUser fUser)async{
    await Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot)
    async{
      await EcommerceApp.setSharePrefercence("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.Point,dataSnapshot[EcommerceApp.Point]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.userLevel, dataSnapshot.data[EcommerceApp.userLevel]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.userSale,"0");
      await EcommerceApp.setSharePrefercence(EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.setSharePrefercence(EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      List<String> cartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartList );

    });

  }
}


