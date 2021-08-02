import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EsportShop/Admin/uploadItems.dart';
import 'package:EsportShop/Authentication/authenication.dart';
import 'package:EsportShop/Authentication/login.dart';
import 'package:EsportShop/Config/config.dart';
import 'package:EsportShop/Widgets/customTextField.dart';
import 'package:EsportShop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.teal,Colors.cyan],
                begin: const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
          "Esport-Shop",style: TextStyle(fontSize: 40.0,color: Colors.white,fontFamily: "RobotoMono-Bold"),

        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.teal,Colors.cyan],
              begin: const FractionalOffset(0.0, 0.0),
              end:  const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            )
        ),

        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/admin.png",
                height: 240.0,
                width: 240.0,),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Admin",
                style: TextStyle(color: Colors.white,fontSize: 28.0,fontWeight: FontWeight.bold),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
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
            SizedBox(height: 25.0,),
            RaisedButton(
              onPressed: (){
                _adminIDTextEditingController.text.isNotEmpty &&
                    _passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    :showDialog(
                    context: context,
                    builder: (c)
                    {
                      return ErrorAlertDialog(message: "Please write email and pass",);
                    }
                );
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
            SizedBox(
              height: 50.0,
            )
          ],
        ),
      ),
    );
  }
  loginAdmin()async{
      Firestore.instance.collection("admins").getDocuments().then((snapshot){
        snapshot.documents.forEach((result) async {
          if(result.data["id"]!= _adminIDTextEditingController.text.trim())
            {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your id is not correct"),));

            }
          else if(result.data["id"]!= _passwordTextEditingController.text.trim())
          {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your password is not correct"),));

          }
          else
            {
            await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.adUser,["garbageValue"] );
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Dear Admin, "+result.data["name"]),));

              setState(() {
                _adminIDTextEditingController.text="";
                _passwordTextEditingController.text="";
              });
              Route route = MaterialPageRoute(builder: (c)=> UploadPage());
              Navigator.pushReplacement(context, route);
            }
        }
      );
  });
}}
