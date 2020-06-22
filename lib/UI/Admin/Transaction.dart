

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loginui/variables/vars.dart';


class transaction extends StatefulWidget {

  var KEYS;
  @override
  _transactionState createState() => _transactionState();
}

class _transactionState extends State<transaction> {
  List<transvar> postedProducts = [];

  void initState(){
    super.initState();

   DatabaseReference req = FirebaseDatabase.instance.reference().child("Requests");
    req.once().then((DataSnapshot snap){
      if(snap.value!=null) {
        widget.KEYS = snap.value.keys;
        var DATA = snap.value;
        print(snap.value.keys);
        postedProducts.clear();
        if (widget.KEYS != null) {
          for (var individualKey in widget.KEYS) {
            transvar trans =
            transvar(

                DATA[individualKey]['confirmationCode'],
                DATA[individualKey]['email'],
                DATA[individualKey]['productImage'],
                DATA[individualKey]['productName'],
                DATA[individualKey]['postedBy'],
                DATA[individualKey]['requestedFrom'],
                DATA[individualKey]['userName'],
                DATA[individualKey]['price'],
                individualKey.toString()
            );
            postedProducts.add(trans);
          }
        }
      }
      else {
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
        title: Text(
          "Transaction",
          style: TextStyle(
              color: fontWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),

        body: Container(


                  color:Colors.white,
                  child: widget.KEYS != null
                      ? GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: postedProducts.length,
                      padding: EdgeInsets.all(5),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return SingleTransaction(
                          postedProducts[index].confirmationCode,
                          postedProducts[index].email,
                          postedProducts[index].productImage,
                          postedProducts[index].productName,
                          postedProducts[index].vendorPhone,
                          postedProducts[index].userPhone,
                          postedProducts[index].userName,
                          postedProducts[index].price,
                          postedProducts[index].ke.toString(),
                        );
                      })
                      : Center(
                      child: Text(
                       "No Products"
                      )),
                ),

    ));
  }
}
class SingleTransaction extends StatefulWidget {
  @override
  _SingleTransactionState createState() => _SingleTransactionState();
  final String confirmationCode;
  final String email;
  final String productImage;
  final String productName;
  final String vendorPhone;
  final String userPhone;
  final String userName;
  final int price;
  final String ke;

  SingleTransaction(
      this.confirmationCode,
      this.email,
      this.productImage,
      this.productName,
      this.vendorPhone,
      this.userPhone,
      this.userName,
      this.price,
      this.ke);
}

class _SingleTransactionState extends State<SingleTransaction> {
  @override
  Widget build(BuildContext context) {
    print("key is ${widget.ke}");
    return SafeArea(
      child: Scaffold(
        body:  widget.ke.isEmpty
            ? Center(
            child: SpinKitWave(
              size: 25,
              color: background_2,
              // controller: AnimationController(duration: Duration(seconds: 30), vs),
            ))
            : GestureDetector(
          onLongPress: () {
            print("Delete");
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure you want to delete',style: TextStyle(fontSize: 16),),

                    actions: <Widget>[
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          setState(() {
                            FirebaseDatabase.instance
                                .reference()
                                .child("Requests")
                                .child(widget.ke)
                                .remove();
                            widget.ke.isEmpty == true;
                            Navigator.of(context).pop();
                            transaction();



                          });
                        },
                      ),
                      FlatButton(
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
                        image: NetworkImage(widget.productImage),
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: <Widget>[
                 Container(
                   alignment: Alignment.center,
                   child: Text(
                     widget.productName,
                     style: TextStyle(fontWeight: FontWeight.w800),
                   ),
                 ),
                 Container(
                   alignment: Alignment.center,
                   child: Text("Code: ${widget.confirmationCode}",
                       style: TextStyle(
                           color: Colors.red)),
                 ),
               ],
             ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                   Text('Posted by:'),
                  Text(widget.vendorPhone.toString())
                ],
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Buyer:'),
                  Text(widget.userPhone.toString())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Buyer Name:'),
                  Text(widget.userName.toString())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Name:'),
                  Text(widget.price.toString())
                ],
              )

            ],
          ),
        ),
      ),

    );
  }
}

class transvar{
  String confirmationCode;
  String email;
  String productImage;
  String productName;
  String vendorPhone;
  String userPhone;
  String userName;
  int price;
  String ke;
  transvar(this.confirmationCode,this.email,this.productImage,this.productName,this.vendorPhone,this.userPhone,this.userName,this.price,this.ke);
}
