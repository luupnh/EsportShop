import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:EsportShop/Config/config.dart';
import 'package:EsportShop/Counters/cartitemcounter.dart';
import 'package:EsportShop/Models/commentmodel.dart';
import 'package:EsportShop/Store/storehome.dart';
import 'package:EsportShop/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';




class CommentAdmin extends StatefulWidget {
  final String iditem;
  CommentAdmin({this.iditem});
  @override
  _CommentAdminState createState() => _CommentAdminState();
}

class _CommentAdminState extends State<CommentAdmin> {
  TextEditingController _commentTextEdittingController = TextEditingController();
  String name = EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
  saveItemInfo(String iditem){
    String a=_commentTextEdittingController.text;
    final itemRef = Firestore.instance.collection("items").document(iditem).collection("comment");
    String time =  DateTime.now().millisecondsSinceEpoch.toString();
    String userid ="ADMIN";
    String docu = userid+time;
    itemRef.document(docu).setData({
      "idcm": docu,
      "cm": a,
      "name":"ADMIN",
    });}

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
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text("Comment",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),),
        actions: [

        ],
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        stream: EcommerceApp.firestore
            .collection("items")
            .document(widget.iditem)
            .collection(EcommerceApp.collectionComment).snapshots(),
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
                  return InFoComment(
                    iditem: widget.iditem,
                    model: CommentModel.fromJson(
                        snapshot.data.documents[index].data),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.perm_device_information,color: Colors.pink,),
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
                      saveItemInfo(widget.iditem);
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
          color: Colors.pink.withOpacity(0.5),
          child: Container(
            height: 100.0,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No reriew for this product "),
              ],
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.perm_device_information,color: Colors.pink,),
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
                saveItemInfo(widget.iditem);
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

  }

}

class InFoComment extends StatefulWidget {
  final CommentModel model;
  final String iditem;
  InFoComment({this.model,this.iditem});


  @override
  _InFoCommentState createState() => _InFoCommentState();
}

class _InFoCommentState extends State<InFoComment> {
  Deletecomment(String idcm){
    EcommerceApp.firestore
        .collection("items")
        .document(widget.iditem)
        .collection(EcommerceApp.collectionComment)
        .document(idcm)
        .delete();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: 170.0,
      width: width,
      child: Row(
        children: [
          SizedBox(width: 10.0,),
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
                        child: Text(widget.model.name,style: TextStyle(color: Colors.red,fontSize: 14.0,fontWeight: FontWeight.bold),),
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
                        child: Text(widget.model.cm,style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Flexible(
                  child: Container(),
                ),
                Divider(height: 5.0,color: Colors.pinkAccent,),
                Align(
                         child: IconButton(
                      icon: Icon(Icons.delete,color: Colors.pinkAccent,),
                      onPressed: (){Deletecomment(widget.model.idcm);
                      },
                    )

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
