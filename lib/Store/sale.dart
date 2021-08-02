import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EsportShop/Address/address.dart';
import 'package:EsportShop/Config/config.dart';
import 'package:EsportShop/Counters/cartitemcounter.dart';
import 'package:EsportShop/Counters/salechangerrr.dart';
import 'package:EsportShop/Models/commentmodel.dart';
import 'package:EsportShop/Models/saleModel.dart';
import 'package:EsportShop/Store/storehome.dart';
import 'package:EsportShop/Widgets/loadingWidget.dart';
import 'package:EsportShop/Widgets/wideButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'cart.dart';



class Sale extends StatefulWidget {

  @override
  _SaleState createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  TextEditingController _commentTextEdittingController = TextEditingController();
  String name = EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
  saveItemInfo(String iditem){
    String a=_commentTextEdittingController.text;
    final itemRef = Firestore.instance.collection("items").document(iditem).collection("comment");
    String time =  DateTime.now().millisecondsSinceEpoch.toString();
    String userid = EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID);
    String docu = userid+time;
    itemRef.document(docu).setData({
      "idcm": docu,
      "cm": a,
      "name":name,
    });}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.teal, Colors.cyan],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
          "Esport-Shop", style: TextStyle(
            fontSize: 40.0, color: Colors.white, fontFamily: "RobotoMono-Bold"),

        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white,),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                },
              ),
              Positioned(
                  child: Stack(
                    children: [
                      Icon(Icons.brightness_1,
                        size: 20.0,
                        color: Colors.red,),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 4.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context,counter,_){
                            return Text(
                              (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                              style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
            ],
          )
        ],
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        stream: EcommerceApp.firestore
            .collection("users")
            .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)
        )
            .collection(EcommerceApp.userSale).snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: circularProgress(),)
              : snapshot.data.documents.length == 0
              ? noAddressCard()
              : Column(
            children: [
              ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InFoSale(
                    model: SaleModel.fromJson(
                        snapshot.data.documents[index].data),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.perm_device_information,color: Colors.black),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    style: TextStyle(color:Colors.deepPurpleAccent),
                    controller: _commentTextEdittingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Center(
                  child: InkWell(
                    onTap: (){
                    },
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
                      width: MediaQuery.of(context).size.width -40.0,
                      height: 50.0,
                      child: Center(
                        child: Text("Comment",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

  }


  noAddressCard() {
    return Column(
      children: [
        Card(
          color: Colors.teal.withOpacity(0.5),
          child: Container(
            height: 100.0,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No sale now "),
              ],
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.perm_device_information,color: Colors.black,),
          title: Container(
            width: 250.0,
            child: TextField(
              style: TextStyle(color:Colors.deepPurpleAccent),
              controller: _commentTextEdittingController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Center(
            child: InkWell(
              onTap: (){
              },
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
                width: MediaQuery.of(context).size.width -40.0,
                height: 50.0,
                child: Center(
                  child: Text("Back ",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InFoSale extends StatefulWidget {
  final SaleModel model;
  final String addressId;
  final int currentIndex;
  final int value;

  InFoSale({Key key,this.model,this.currentIndex,this.addressId,this.value}): super(key:  key);


  @override
  _InFoSaleState createState() => _InFoSaleState();
}

class _InFoSaleState extends State<InFoSale> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<SaleChanger>(context,listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.teal,
                  onChanged: (val){
                    Provider.of<SaleChanger>(context,listen: false).displayResult(val);
                  },

                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth*0.8,
                      child: Table(
                        children: [
                          TableRow(
                              children: [
                                KeyText(msg: "Sale Code",),
                                Text(widget.model.idsale),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Sale %",),
                                Text(widget.model.sale),
                              ]
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            WideButton(
              message: "Chose",
              onPressed: ()
              {
                String sale =widget.model.sale;
                 EcommerceApp.sharedPreferences.setString(EcommerceApp.userSale,sale);
                          Navigator.pop(context);
                     },
            )
          ],
        ),
      ),
    );
  }
}
