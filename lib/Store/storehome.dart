import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EsportShop/Store/cart.dart';
import 'package:EsportShop/Store/product_page.dart';
import 'package:EsportShop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:EsportShop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:EsportShop/Store/horizonlv.dart';


double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(

          flexibleSpace : Container(
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
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart,color: Colors.pink,),
                  onPressed: ()
                  {
                    Route route = MaterialPageRoute(builder: (c)=> CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(Icons.brightness_1,
                        size: 20.0,
                        color: Colors.black,),
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
        drawer: MyDrawer(),
        body:
        CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true,delegate: SearchBoxDelegate(),),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("items").limit(15).orderBy("publishedDate",descending: true).snapshots(),
                builder: (context,dataSnapshot)
                {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                      : SliverStaggeredGrid.countBuilder(crossAxisCount: 1, staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                    itemBuilder: (context,index){
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                      String iditem = dataSnapshot.data.documents[index].documentID;
                      return sourceInfo(model, context,iditem);
                    }, itemCount: dataSnapshot.data.documents.length,);
                }
            )
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,String iditem,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c)=>ProductPage(itemModel:model,iditem: iditem,));
      Navigator.push(context, route);

    },
    splashColor: Colors.teal,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140.0,height: 140.0,),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 20.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.shortInfo,style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    children: [
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text("Price: ",style: TextStyle(fontSize: 18.0,color: Colors.grey),),
                                Text((model.price).toString(),
                                  style: TextStyle(fontSize: 20.0,color: Colors.black),),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text("Quantity: ",style: TextStyle(fontSize: 18.0,color: Colors.grey),),
                                Text((model.quantity).toString(),
                                  style: TextStyle(fontSize: 20.0,color: Colors.black),),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.add_shopping_cart,color: Colors.black,),
                        onPressed: (){
                          checkItemInCart(model.id,model, context);
                        },
                      )
                  ),
                  Divider(height: 5.0,color: Colors.black,)
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Future<bool> _onWillPop() {
  return showDialog(
    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to exit an App'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        FlatButton(
          onPressed: () => exit(0),
          /*Navigator.of(context).pop(true)*/
          child: Text('Yes'),
        ),
      ],
    ),
  ) ??
      false;
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width*.34,
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(offset: Offset(0,5),blurRadius: 10.0,color: Colors.grey[200]),
        ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width*.34,
        fit: BoxFit.fill ,
      ),
    ),
  );
}



void checkItemInCart(String id,ItemModel model, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(id)
      ? Fluttertoast.showToast(msg: "Item is aldeady in Cart")
      : addItemToCart(id,model,context);
}

addItemToCart(String id,ItemModel model,BuildContext context){
  List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(id);
  final itemRef = Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.userCartList);
  itemRef.document(id).setData({
    "id":id,
    "shortInfo": model.shortInfo,
    "longDescription": model.longDescription,
    "price": model.price,
    "quantity": 1,
    "thumbnailUrl": model.thumbnailUrl,
    "title": model.title,
  }
  );
  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({
  EcommerceApp.userCartList: tempCartList});
  EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
  Fluttertoast.showToast(msg: "Item Add Success");
  Provider.of<CartItemCounter>(context,listen: false).displayResult();
}
Widget image_carousel = new Container(
  height: 200.0,
  child: new CarouselSlider(
    options: CarouselOptions(height: 400.0),
    items: [1,2,3,4].map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: Image.asset('images/cash.png'),
          );
        },
      );
    }).toList(),
  ),
);