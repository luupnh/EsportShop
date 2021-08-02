import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EsportShop/Config/config.dart';
import 'package:EsportShop/Address/address.dart';
import 'package:EsportShop/Store/product_page.dart';
import 'package:EsportShop/Store/sale.dart';
import 'package:EsportShop/Widgets/customAppBar.dart';
import 'package:EsportShop/Widgets/loadingWidget.dart';
import 'package:EsportShop/Models/item.dart';
import 'package:EsportShop/Counters/cartitemcounter.dart';
import 'package:EsportShop/Counters/totalMoney.dart';
import 'package:EsportShop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:EsportShop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;
  String sales = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount =0;
    sales = EcommerceApp.sharedPreferences.getString(EcommerceApp.userSale);
    Provider.of<TotalAmount>(context,listen: false).display(0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
                  return Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child:
                      InkWell(
                        onTap: () {
                          Route route = MaterialPageRoute(builder: (c) =>
                              Address(totalAmount: totalAmount,));
                          Navigator.push(context, route);
                        },
                        child: Text("Total Price : ${amountProvider.totalAmount
                            .toString()}" + "  VND " + " - CHECK OUT",
                          style: TextStyle(color: Colors.red,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: EcommerceApp.firestore.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection("userCart").snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                  child: Center(child: circularProgress(),),
                )
                    : snapshot.data.documents.length == 0
                    ? beginBuildingCart()
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      ItemModel model = ItemModel.fromJson(
                          snapshot.data.documents[index].data);
                      String iditem = snapshot.data.documents[index].documentID;
                      double sale = double.tryParse(sales);
                      sale = sale / 100;
                      double salenow = 1 - sale;
                      if (index == 0) {
                        totalAmount = 0;
                        totalAmount =
                            (model.price * model.quantity + totalAmount)
                                ;
                      }
                      else {
                        totalAmount =
                            (model.price * model.quantity + totalAmount) ;
                      }
                      if (snapshot.data.documents.length - 1 == index) {
                        totalAmount = totalAmount*salenow;
                        WidgetsBinding.instance.addPostFrameCallback((t) {
                          Provider.of<TotalAmount>(context, listen: false)
                              .display(totalAmount);
                        });
                      }
                      return sourceInfoCart(model, context, iditem,
                          removeCartFunction: () =>
                              removeItemFromUserCart(model.id));
                    },
                    childCount: snapshot.hasData ? snapshot.data.documents
                        .length : 0,
                  ),
                );
              }
          )
        ],
      ),
    );
  }
  beginBuildingCart(){
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Empty"),
            ],
          ),
        ),
      ),
    );
  }
  removeItemFromUserCart(String iditem){
    List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList)
        .document(iditem)
        .delete();
    tempCartList.remove(iditem);
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
        EcommerceApp.userCartList: tempCartList});
    Fluttertoast.showToast(msg: "Remove Success");
    Provider.of<CartItemCounter>(context,listen: false).displayResult();
    totalAmount =0;
  }
}
updatequan(String iditem,int quan)
{
  final itemRef = Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)).collection(EcommerceApp.userCartList);
  itemRef.document(iditem).updateData({
    "quantity": quan,});
}

Widget sourceInfoCart(ItemModel model, BuildContext context,String iditem,
    {Color background, removeCartFunction}) {
  int quantity =model.quantity;
  return InkWell(
    onTap: (){

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
                          child: Text(model.title,style: TextStyle(color: Colors.black,fontSize: 14.0),),
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
                                Text("Price: ",style: TextStyle(fontSize: 14.0,color: Colors.grey),),
                                Text((model.price).toString(),
                                  style: TextStyle(fontSize: 15.0,color: Colors.black),),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text("Quantity: ",style: TextStyle(fontSize: 14.0,color: Colors.grey),),
                                Text((quantity).toString(),
                                  style: TextStyle(fontSize: 15.0,color: Colors.black),),
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
                  Row(
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete,color: Colors.black,),
                            onPressed: (){removeCartFunction();
                            },
                          )
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(Icons.plus_one,color: Colors.black,),
                            onPressed: (){
                              quantity = model.quantity+1;
                              updatequan(iditem, quantity);

                            },
                          )
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child:IconButton(
                            icon: Icon(Icons.exposure_minus_1,color: Colors.black,),
                            onPressed: (){
                              if(quantity>1)
                              {   quantity = model.quantity-1;
                              updatequan(iditem, quantity);
                              }
                            },
                          )
                      ),
                    ],
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