import 'package:admin/add_products.dart';
import 'package:admin/users.dart';
import 'package:admin/view_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'orders.dart';
//import 'package:fluttertoast/fluttertoast.dart';

enum Page { dashboard, manage }

class Administrator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp
    (
      debugShowCheckedModeBanner: false,
      theme: new ThemeData
      (
        primarySwatch: Colors.pink
      ),
    home: Admin(),      
    );
  }
}

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.pink;
  MaterialColor notActive = Colors.grey;
  UserService userService = UserService();
  var usersCount=0,productsCount=0,ordersCount=0;

  void getNumberOfUsers() async
  {
      List<DocumentSnapshot> data = await userService.getUsers();
      setState(() {
        usersCount=data.length;
      });
      
  }

  void getNumberOfOrders() async
  {
      List<DocumentSnapshot> data = await userService.getOrders();
      setState(() {
        ordersCount=data.length;
      });
      
  }

  void getNumberOfProducts() async
  {
    List<DocumentSnapshot> data = await userService.getProducts();
    setState(() {
      productsCount=data.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getNumberOfUsers();
    getNumberOfProducts();
    getNumberOfOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '$usersCount',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Products")),
                          subtitle: Text(
                            '$productsCount',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),

                   Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.store),
                              label: Text("Orders")),
                          subtitle: Text(
                            '$ordersCount',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon
              (
                Icons.add,
              ),
              title: Text("Add product"),
              onTap: () 
              {
                Navigator.push(
                  context, MaterialPageRoute(builder: (BuildContext context) => Add()));
              },
            ),
            ListTile(
              leading: Icon
              (
                Icons.view_list,
              ),
              title: Text("View Products"),
              onTap: () 
              {
                Navigator.push(
                  context, MaterialPageRoute(builder: (BuildContext context) => Primary()));
              },
            ),
            ListTile(
              leading: Icon
              (
                Icons.people,
              ),
              title: Text("Orders"),
              onTap: () 
              {
                Navigator.push(
                  context, MaterialPageRoute(builder: (BuildContext context) => Omain()));
              },
            ),
          ],
        );
        break;
      default:
        return Container();
    }
  }
}