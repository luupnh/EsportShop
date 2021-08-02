import 'package:EsportShop/Authentication/authenication.dart';
import 'package:EsportShop/BankCard/addBankCard.dart';
import 'package:EsportShop/Config/config.dart';
import 'package:EsportShop/Address/addAddress.dart';
import 'package:EsportShop/Orders/UserHistory.dart';
import 'package:EsportShop/Store/Search.dart';
import 'package:EsportShop/Store/cart.dart';
import 'package:EsportShop/Orders/myOrders.dart';
import 'package:EsportShop/Store/storehome.dart';
import 'package:EsportShop/Store/userprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
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
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: CircleAvatar(
                    ),
                  ),

                SizedBox( height:10.0,),
                Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                style: TextStyle(color: Colors.white,fontSize: 35.0,fontFamily: "RobotoMono-Bold"),),
              ],
            ),
          ),
          SizedBox(height: 12.0,),
          Container(
              padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
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
              children: [
                ListTile(
                  leading: Icon(Icons.home,color:Colors.white,),
                  title: Text("Home", style: TextStyle(color: Colors.white, fontSize: 20),),
                  onTap: (){
                  Route route = MaterialPageRoute(builder: (c)=> StoreHome());
                  Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("My Order", style: TextStyle(color: Colors.white, fontSize: 20),),
                  leading: Icon(Icons.card_travel,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> MyOrders());
                    Navigator.push(context, route);
                  },
                ),

                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("New Address", style: TextStyle(color: Colors.white, fontSize: 20),),
                  leading: Icon(Icons.add_location,color:Colors.white,),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> AddAddress());
                    Navigator.push(context, route);

                  },
                ),

                Divider(height: 10.0,color: Colors.white,thickness: 6.0,),
                ListTile(
                  title: Text("Log out", style: TextStyle(color: Colors.white, fontSize: 20),),
                  leading: Icon(Icons.exit_to_app,color:Colors.white,),
                  onTap: (){
                    EcommerceApp.auth.signOut().then((c) async {
                      await EcommerceApp.setSharePrefercence("uid", "");
                      await EcommerceApp.setSharePrefercence(EcommerceApp.Point,"");
                      await EcommerceApp.setSharePrefercence(EcommerceApp.userLevel, "");
                      await EcommerceApp.setSharePrefercence(EcommerceApp.userSale,"0");
                      await EcommerceApp.setSharePrefercence(EcommerceApp.userEmail, "");
                      await EcommerceApp.setSharePrefercence(EcommerceApp.userName, "");
                      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,["garbageValue"] );
                      Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
