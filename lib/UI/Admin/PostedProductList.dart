import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loginui/UI/Admin/Post.dart';

import 'package:loginui/variables/PostVar.dart';

import 'package:loginui/variables/vars.dart';


class PostedProduct extends StatefulWidget {
  final String category;
  var KEYS;

  PostedProduct(this.category);

  @override
  PostedProductState createState() =>
      PostedProductState();
}

class PostedProductState
    extends State<PostedProduct> {
  List<PostVar> postedProducts = [];
  FirebaseAuth _auth;
  FirebaseUser user;
  var connectivity;
  bool check = false;
  String currentState;


  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await(Connectivity().checkConnectivity());
    print(user.email.toString());
  }


  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
    print("The category is ${widget.category}");
    //Query query = FirebaseDatabase.instance.reference().child("products").equalTo("car");
//Query query = FirebaseDatabase.instance.reference().child("product").orderByChild("productCategory").equalTo(productCategory.text);
    FirebaseDatabase.instance.reference().keepSynced(true);
    Query postedRef = FirebaseDatabase.instance
        .reference()
        .child("product")
        .orderByChild("productCategory")
        .equalTo(widget.category);

    postedRef.once().then((DataSnapshot snap) {
      widget.KEYS = snap.value.keys;
      var DATA = snap.value;
      print(snap.value.keys);
      postedProducts.clear();
      if (widget.KEYS != null) {
        for (var individualKey in widget.KEYS) {
          if (DATA[individualKey]['privilege'] == user.email) {
            check = true;
            PostVar postVar = PostVar(
                DATA[individualKey]['productName'],
                DATA[individualKey]['productDescription'],
                DATA[individualKey]['productPrice'],
                DATA[individualKey]['productCategory'],
                DATA[individualKey]['image_0'],
                DATA[individualKey]['image_1'],
                DATA[individualKey]['image_2'],
                DATA[individualKey]['Privilege'],
                // DATA[individualKey]['image_3'],
                individualKey.toString());
            postedProducts.add(postVar);
          }
        }
      } else {
        print("No product posted in this category");
      }
      setState(() {
        print("Lenght: ${postedProducts.length}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background_2,
      appBar: AppBar(
        backgroundColor: background_2,
        title:  Text(
          widget.category,
          style: TextStyle(
              color: fontWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
     ),

        body:  Container(
                    color: Colors.white,
                    child: postedProducts.isNotEmpty ? GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: postedProducts.length,
                        padding: EdgeInsets.all(5),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return SingleCategory(
                            postedProducts[index].productName,
                            postedProducts[index].productDescription,
                            postedProducts[index].productPrice,
                            postedProducts[index].productCategory,
                            postedProducts[index].image_0,
                            postedProducts[index].image_1,
                            postedProducts[index].image_2,
                            postedProducts[index].key.toString(),
                          );
                        }):

                    Center(
                      child: Text("No product")
                    )

                ),


         floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Post()));
//
//                    },
      },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: background_2,),
      ),
    );
  }
}

class SingleCategory extends StatefulWidget {
  @override
  _SingleCategoryState createState() => _SingleCategoryState();
  final String productName;
  final String productDescription;
  final int productPrice;
  final String productCategory;
  final String productImage_0;
  final String productImage_1;
  final String productImage_2;

  //final String productImage_3;
  final String ke;

  SingleCategory(this.productName,
      this.productDescription,
      this.productPrice,
      this.productCategory,
      this.productImage_0,
      this.productImage_1,
      this.productImage_2,
      //this.productImage_3,
      this.ke);
}

class _SingleCategoryState extends State<SingleCategory> {
  @override
  Widget build(BuildContext context) {
    print("key is ${widget.ke}");
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onLongPress: () {
            print("Delete");
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure you want to delete!!'),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text('Yes'),
                        onPressed: () {
                          FirebaseDatabase.instance
                              .reference()
                              .child("product")
                              .child(widget.ke)
                              .remove();
                          widget.ke.isEmpty == true;
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      RaisedButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          },

          child: Column(
            children: <Widget>[
              Expanded(
                child: Card(
                    child: GridTile(
                      child: FadeInImage(
                        placeholder:
                        AssetImage('assets/images/men1.jpeg'),
                        image: NetworkImage(widget.productImage_0),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.productName,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('${widget.productPrice} ETB'.toString(),
                    style: TextStyle(
                        color: Colors.red)),
              ),
            ],
          ),
        ),

      ),

    );
  }
}
