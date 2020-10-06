import 'dart:async';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

ProgressDialog pr;
TextEditingController name = new TextEditingController();
TextEditingController oldPrice = new TextEditingController();
TextEditingController price = new TextEditingController();
bool value = true,value1=true;

final Firestore firestore = Firestore.instance;


class Add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp
    (
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch:Colors.pink),
      home: MyHomePage(),  
    );
  }
}




class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File sampleImage;

  @override
  void initState() {
    super.initState();
    sampleImage = null;
    value=true;
    value1=true;
  }

  final formKey = GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }
  @override
  Widget build(BuildContext context) {

  pr = new ProgressDialog(context);

  pr.style(
  message: 'Adding Prdouct...',
  borderRadius: 10.0,
  backgroundColor: Colors.white,
  progressWidget: CircularProgressIndicator(),
  elevation: 10.0,
  insetAnimCurve: Curves.easeInOut,
  progress: 0.0,
  maxProgress: 100.0,
  progressTextStyle: TextStyle(
     color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
  messageTextStyle: TextStyle(
     color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
  );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Your Products'),
        centerTitle: true,
      ),
      body: new Form
      (
        key: formKey,
        child: ListView
      (
        children: <Widget>
        [
         Padding(
                padding: const EdgeInsets.only(left: 20.0, right:20.0,top: 20.0),
                child: TextFormField
                (                
                  decoration: InputDecoration
                  (
                    hintText: "Enter product name",
                  ),
                  controller: name,
                  validator: (value)
                  {
                    return value.isEmpty ? 'product name is reqired ' : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right:20.0),
                child: TextFormField
                (
                  decoration: InputDecoration
                  (
                    hintText: "Enter old price",
                  ),
                  controller: oldPrice,
                  validator: (value)
                  {
                    return value.isEmpty ? 'old price is required' : null;
                  },
                ),
              ),

           Padding(
                padding: const EdgeInsets.only(left: 20.0, right:20.0),
                child: TextFormField
                (
                  decoration: InputDecoration
                  (
                    hintText: "Enter product price",
                  ),
                  controller: price,
                  validator: (value)
                  {
                    return value.isEmpty ? 'price is required' : null;
                  },
                ),
              ),

          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Center(child: sampleImage == null ? Text(""): enableUpload(),),
          ),
          Visibility(
                      child: Padding(
              padding: const EdgeInsets.only(left:140.0,right: 140.0,top:10.0),
                child: RaisedButton
                (
                  color: Colors.pink,
                  onPressed: ()
                  {
                    getImage();
                    setState(() {
                      value = false;
                    });
                  },
                  child: Text("Add Image",style:TextStyle(color: Colors.white)),
                ),
            ),
            visible: value,
          )
        ],
      ),
      ),
    );
  }

  //adding products in database

  Widget enableUpload(){
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 300.0,width: 300.0),
          Visibility(
              child: RaisedButton(
              elevation: 7.0,
              child: Text('Add product'),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: () async {
                FormState formState = formKey.currentState;
                if(formState.validate())
                {
                pr.show();
                final StorageReference firebaseStorageRef = 
                    FirebaseStorage.instance.ref().child("${name.text}.jpg");
                final StorageUploadTask task = 
                    firebaseStorageRef.putFile(sampleImage);
                    task.onComplete.then((value) async {
                  pr.hide();
                  String url = (await firebaseStorageRef.getDownloadURL()).toString();
                  var id = Uuid();
                  String uuid = id.v1(); 
                  firestore.collection("products").document(uuid).setData(
                    {
                      "name":name.text,
                      "oldPrice":oldPrice.text,
                      "price":price.text,
                      "picture":url,
                      "product id":uuid.toString(),
                    });
                  setState(() {
                    value1=false;
                  });
                  formState.reset();
                  Fluttertoast.showToast(msg: "Product Added Successfully");
                  Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (BuildContext context) => Add()));
                });
                }
              },
              ),
              visible: value1,
          )
        ],
      ),
    );
  }
}