import 'package:admin/add_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'admin.dart';
String pName,orderID,userID;

class Omain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(primarySwatch:Colors.pink),
      home: Orders(),
    );
  }
}

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  @override
  Widget build(BuildContext context) {
     return Scaffold
    (
       appBar: AppBar(title:Text("Orders"),actions: <Widget>
       [
         IconButton(icon: Icon(Icons.refresh), onPressed: ()
         {
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => Orders ()));
         })
       ],),
       body: Data(),  
    );
  }
}


class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {

 // Remove orders starts

 createOrdersDeleteDialog(BuildContext context,String pname,String orderId,String userId)
 {

   return showDialog
   (
     context:context,
     builder:(context)
     {
       return AlertDialog
       (
         title: Text("Do You Want Cancel Order",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold)),
         actions: <Widget>
         [
           FlatButton(onPressed: ()
           {
              firestore.collection("orders").document(orderId).delete();
              firestore.collection(userId).document(orderId).delete();
              Fluttertoast.showToast(msg: "Order has been cancelled");   
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Admin()));    
           }, child: Text("Yes",style:TextStyle(color: Colors.pink,fontWeight:FontWeight.bold,fontSize:18.0)),color: Colors.white,),
           FlatButton(onPressed: ()
           {
              Navigator.of(context).pop();
           }, child: Text("No",style:TextStyle(color: Colors.pink,fontWeight:FontWeight.bold,fontSize:18.0)),color: Colors.white,)
         ],
       );
     }
   ); 
 }

//Remove orders ends


  Future getProducts () async
  {
    var firestore = Firestore.instance;
    QuerySnapshot data =await firestore.collection("orders").getDocuments();
    return data.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:0.0),
      child: Container(
        child:FutureBuilder
        (
          future: getProducts(),
          builder: (context,snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child:Text("Loading .......",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),));
            else
            {
               return GridView.builder
               (
                 itemCount: snapshot.data.length,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1) ,
                 itemBuilder: (context,index)
                 {
                  return Card
                   (
                     child: Hero
                     (
                      tag: new Text("hero"),
                      child: Material
                      (
                       child: InkWell
                       (
                        onTap: ()
                        {
                              setState(() {
                                pName = snapshot.data[index].data['product name'];
                                userID = snapshot.data[index].data['id'];
                                orderID = snapshot.data[index].data['random id'];
                              });
                              createOrdersDeleteDialog(context,pName,orderID,userID);
                        },
                         child: GridTile
                        (
                          footer: Container
                          (
                             height: 50.0,
                             color: Colors.white,
                             child: new Column
                             (
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>
                              [
                               Text("Customer Name : ${snapshot.data[index].data['name']}",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                               Text("Product Name      : ${snapshot.data[index].data['product name']}",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,)),
                               Text("Price                      : ${snapshot.data[index].data['price']}",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,))
                              ],
                            )
                          ),
                           child: Container(height:50.0,child: Image.network("${snapshot.data[index].data['picture']}",fit: BoxFit.cover,)),
                        ),
                        ),
                      ),
                      ),
                    );
                   }
                );
            }
          },
        )
      ),
    );
  }
}