import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loginui/variables/ProductList.dart';


class CategoriesList extends StatefulWidget {

  CategoriesList();
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {

  DatabaseReference productRef =
  FirebaseDatabase.instance.reference().child("catagory");
  Color background_2 = Color(0XFF738989);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: StreamBuilder(
          stream: productRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
              //map.forEach((dynamic,category)=>print(category["type"]));
              //print("the map is ${map.values.toList()}");
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: map.values.toList().length,
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onLongPress: (){
                        return showDialog(context: (context),
                        builder: (context){
                          return AlertDialog(
                              title: Text('Are you sure you want to delete!!'),
                            actions: <Widget>[
                              RaisedButton(
                                child:Text('No'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              ),
                              RaisedButton(
                                child: Text('Yes'),
                                onPressed: (){
                                  //print("category deleted");
                                  setState(() {
                                    if(map.values.toList().length>1){
                                    FirebaseDatabase.instance.reference().child("catagory").child(map.keys.toList()[index]).remove();
                                    Navigator.of(context).pop();

                                    }
                                    else{
                                    print("not deleted");
                                   _showSnackBar("There must be at leat one category");
                                    //,duration: Duration(seconds: 3),icon:Icon(Icons.warning),isDismissible: true);
                                    Navigator.of(context).pop();
                                    }

                                  });

                                },
                              )
                            ],
                          );
                        }

                        );


                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductList(
                                map.values.toList()[index]["type"])));
                      },
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.white24,


                                child: GridTile(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          map.values.toList()[index]["image"]),
                                      placeholder: AssetImage('assets/images/cart.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),


                                )),
                          ),
                          Text(
                            map.values.toList()[index]["type"],overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return Center(
                child: SpinKitWave(
                  size: 25,
                  color: background_2,
                  // controller: AnimationController(duration: Duration(seconds: 30), vs),
                ));
          }),
    );
  }
}
final GlobalKey<ScaffoldState> _scaffoldkey=  GlobalKey<ScaffoldState>();

_showSnackBar(String content){
  final snackBar = SnackBar(
      content:Text(content),
      duration: Duration(seconds:2)
  );

  _scaffoldkey.currentState.showSnackBar(snackBar);

}