import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'admin.dart';

String pID;

class Primary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp
    (
       debugShowCheckedModeBanner: false,
       theme: ThemeData(primarySwatch:Colors.pink),  
       home: Retreive(),
    );
  }
}


class Retreive extends StatefulWidget {
  @override
  _RetreiveState createState() => _RetreiveState();
}

class _RetreiveState extends State<Retreive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
       appBar: AppBar(title:Text("Products Available"),actions: <Widget>
       [
         IconButton(icon: Icon(Icons.refresh), onPressed: ()
         {
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => Retreive ()));
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

 // create an alert dialog for delete starts

   createDeleteDialog(BuildContext context,String pId)
   {
      return showDialog(context: context,builder: (context)
      {
        return AlertDialog
        (
          title: Text("Do You Want To Delete The Product",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold)),
          actions: <Widget>
         [
           FlatButton(onPressed: ()
           {
              Firestore.instance.collection("products").document(pId).delete();  
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "product deleted successfully");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Admin()));    
           }, child: Text("Yes",style:TextStyle(color: Colors.pink,fontWeight:FontWeight.bold,fontSize:18.0)),color: Colors.white,),
           FlatButton(onPressed: ()
           {
              Navigator.of(context).pop();
           }, child: Text("No",style:TextStyle(color: Colors.pink,fontWeight:FontWeight.bold,fontSize:18.0)),color: Colors.white,)
         ],
        );
      });
   }

// create an alert dialog for delete starts



  // displays all the prdocuts available in the shop
  Future getProducts () async
  {
    var firestore = Firestore.instance;
    QuerySnapshot data =await firestore.collection("products").getDocuments();
    return data.documents;
  }
  // displays all the prdocuts available in the shop

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
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) ,
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
                            pID = snapshot.data[index].data['product id'].toString();
                          });
                          createDeleteDialog(context,pID);
                        },
                         child: GridTile
                        (
                          footer: Container
                          (
                             height: 30.0,
                             color: Colors.white,
                             child: new Row
                             (
                              children: <Widget>
                              [
                                Expanded
                                (
                                 child: Text("${snapshot.data[index].data['name']}",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                                 ),
                               new Text("${snapshot.data[index].data['price']}",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,))
                              ],
                            )
                          ),
                           child: Image.network("${snapshot.data[index].data['picture']}",fit: BoxFit.cover,),
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