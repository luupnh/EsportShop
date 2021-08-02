import 'package:EsportShop/Authentication/authenication.dart';
import 'package:EsportShop/Config/config.dart';
import 'package:EsportShop/Address/addAddress.dart';
import 'package:EsportShop/Orders/UserHistory.dart';
import 'package:EsportShop/Store/Search.dart';
import 'package:EsportShop/Store/cart.dart';
import 'package:EsportShop/Orders/myOrders.dart';
import 'package:EsportShop/Store/storehome.dart';
import 'package:EsportShop/Store/storehomedefault.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawerDefault extends StatelessWidget {
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
                Text("Empty",
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
                    Route route = MaterialPageRoute(builder: (c)=> StoreHomeDefault());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment_ind,color:Colors.white,),
                  title: Text("Sign Up/In", style: TextStyle(color: Colors.white, fontSize: 20),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen());
                    Navigator.push(context, route);
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
