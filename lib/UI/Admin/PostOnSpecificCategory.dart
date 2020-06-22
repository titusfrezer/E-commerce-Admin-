import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loginui/variables/AdminMultiSelectSpecific.dart';
import 'package:loginui/variables/SpecificCategoryList.dart';
import 'package:loginui/variables/vars.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

DatabaseReference productRef,catRef,usersRef;
class PostOnSpecificCategory extends StatefulWidget {
  final String categoryName;
  PostOnSpecificCategory(this.categoryName);

  @override
  _PostOnSpecificCategoryState createState() => _PostOnSpecificCategoryState();
}

class _PostOnSpecificCategoryState extends State<PostOnSpecificCategory> {
  List<Asset> images = List<Asset>();
  List<Asset> categoryImage = List<Asset>();
  String _error = 'No Error Dectected';
  DateTime myDate = DateTime.now();
  FirebaseAuth _auth;
  FirebaseUser user;

  getCurrentUser() async{
    user = await _auth.currentUser();
    print(user.email.toString());
  }
  void initState() {
    super.initState();
    loading=false;
    _auth=FirebaseAuth.instance;
    getCurrentUser();
    categoryHint = "Product Name";
    detailHint = "Product Detail";
    priceHint = "Product Price";
    productRef = FirebaseDatabase.instance.reference().child("product");
    catRef=FirebaseDatabase.instance.reference().child("catagory");
    usersRef = FirebaseDatabase.instance.reference().child("Users");

  }

  Widget buildGridView() {

    return GridView.count(
      crossAxisSpacing: 10,
      crossAxisCount: 4,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#4E5050",
          actionBarTitle: "Shopping App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      print(resultList);
      _error = error;
    });
  }
  Widget buildGridViewCategory() {
    return Container(
      width: 100,
      child: GridView.count(

        crossAxisCount: 1,
        children: List.generate(categoryImage.length, (index) {
          Asset asset = categoryImage[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      ),
    );
  }
  Future<void> categoryImages() async {
    List<Asset> resultListCategory = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultListCategory = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: categoryImage,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#4E5050",
          actionBarTitle: "Shopping App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      categoryImage = resultListCategory;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {

    double textFieldWidth = MediaQuery.of(context).size.width * 0.5;
    double textWidth = MediaQuery.of(context).size.width * 0.3;
    return SafeArea(
        child: Scaffold(
          key:_scaffoldkey,
          backgroundColor: background_2,
          drawer: Drawer(

          ),
          appBar: AppBar(
            title: Text(
              widget.categoryName,
              style: TextStyle(color:fontWhite),
            ),
            backgroundColor: Colors.white24,
            actions: <Widget>[

              Container(
                child: loading == true? Center(
                  child: SpinKitWave(
                    size: 25,
                    color: fontWhite,
                  ),
                ): FlatButton(
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),

                  onPressed: () async {


                    print(selectedCategoryList);

                    var connectivity = await(Connectivity().checkConnectivity());
                    //print(connectivity);
                    if(connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi) {


                      if(productName.text.isNotEmpty&&productDetail.text.isNotEmpty&&productPrice.text.isNotEmpty&&images.isNotEmpty&&images.length==3){

                        setState(() {
                          loading = true;
                        });
//                            await catRef.once().then((DataSnapshot snap){
//                              var KEYS = snap.value.keys;
//                              var DATA = snap.value;
//                              print("the text written is ${productCategory.text} and ");
//                              for (var individualKey in KEYS) {
//                                print("${DATA[individualKey]['type']}");
//                                if(productCategory.text == DATA[individualKey]['type']) {
//                                  counter++;
//                                }
//                              }
//
//                            });
//                            if(counter==0){
//                              await catRef.push().set(<dynamic, dynamic>{
//                                'type': productCategory.text
//                              });
//                            }

                        await uploadtoFirebase(images,widget.categoryName,user);
                        await Navigator.pop(context);
//                            await Navigator.of(context).push(
//                                MaterialPageRoute(
//                                    builder: (context) => SpecificCategoryListVendor(widget.categoryName)));
                        print("Empty fields");

                      }
                      else {
                        setState(() {
                         // int.parse(productPrice.text);
                          if(productName.text== ""){
                            categoryHint = "Empty Field";
                          }if(productDetail.text== ""){
                            detailHint = "Empty Field";
                          }if(productPrice.text== "" ){
                            priceHint = "Empty Field";
                          }if(images.length!=3){
                            print("empty image");
                            _showSnackBar("Add exactly 3 Product images");
                          }
                          if(images.isEmpty){

                            print("empty image");
                            _showSnackBar("Add Product Image");
                          }if(categoryImage==null){
                            _showSnackBar("Add Category Image");
                          }
                        });

                      }
                    }
                    else{
                      print("check internet connection");
                      _showSnackBar("Check your Internet connectiton");
                    }
                  },
                  child: Text("Post",
                      style: TextStyle(
                        color: fontWhite,
                        fontSize: 20,
                      )),
                ),
              ),
            ],
          ),
          body: Column(
            //scrollDirection: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: <Widget>[
                          ResuableRow("Product Name", productName, context,categoryHint),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: AutoSizeText('Product Detail',
                                    maxLines: 1,
                                    minFontSize: 16,
                                    style: TextStyle(
                                        color: fontWhite, fontWeight: FontWeight.w600)),
                                width: textWidth,
                              ),
                              Container(

                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  shape: BoxShape.rectangle,

                                  // borderRadius: BorderRadius.all(Radius.circular(50))
                                ),
                                width: textFieldWidth,
                                height: 100,
                                child: TextField(

                                  maxLines: 5,
                                  cursorColor: fontWhite,
                                  controller: productDetail,

                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: fontWhite),
                                  decoration: InputDecoration(

                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent)),
                                      hoverColor: Colors.white10,
                                      fillColor: Colors.white,
                                      hintText: detailHint,
                                      hintStyle: TextStyle(color: detailHint != "Empty Field"? fontWhite: Colors.red)),

                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ResuableRow("Product Price", productPrice, context,priceHint)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    child: AutoSizeText('Select Product Image',
                                        maxLines: 1,
                                        minFontSize: 17,
                                        style: TextStyle(
                                            color: fontWhite,
                                            fontWeight: FontWeight.w600))),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Text("Pick Images"),
                                  onPressed: loadAssets,
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 50,
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: buildGridView()),

                        ],
                      ),
                    ),
//
                    Container(

                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15,top: 15),
                            child: Text("Select Additional Categories",
                                style: TextStyle(
                                    color: background_2,
                                    fontSize: fontHeader,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            height: 300,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 10,bottom: 10),
                            child: AdminMultiSelectSpecific(widget.categoryName),

                          )
                        ],
                      ),
                    ),
                  ],

                ),
              ),


            ],

          ),


        ));
  }
}

Future<String> upload(Asset Image) async {

  ByteData byteData = await Image.getByteData(quality: 20);
  List<int> imageData = byteData.buffer.asUint8List();
  StorageReference ref = FirebaseStorage.instance.ref().child(Image.name);
  StorageUploadTask uploadTask = ref.putData(imageData);
  var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
  var url = dowurl.toString();
  return url;
}

Future uploadtoFirebase(List<Asset> Image,String categoryName,FirebaseUser user) async{
  List url;
  var vendorPhone;
  for (var i=0;i<Image.length;i++){
    var url = await upload(Image[i]);
    listurl.add(url);

  }
//  var url1= await upload(image1);
//  listurl.add(url1);
//  var url2 = await upload(image2);
//  listurl.add(url2);
//  var url3= await upload(image3);
//  listurl.add(url3);
//  var url4 = await upload(image4);
//  listurl.add(url4);
  await usersRef.once().then((DataSnapshot snap) {
    var KEYS = snap.value.keys;
    var DATA = snap.value;

    for (var individualKey in KEYS) {
      if (DATA[individualKey]['email'] == user.email) {
        vendorPhone = DATA[individualKey]['identity'];
      }
    }
  });

  await productRef.push().set(<dynamic, dynamic> {

    'productName': productName.text.toString(),
    'firstLetter':productName.text.toString()[0],
    'productDescription': productDetail.text.toString(),
    'productPrice': int.parse(productPrice.text.toString()),
    'productCategory': categoryName,
    'image_0': "${listurl[0]}",
    'image_1': "${listurl[1]}",
    'image_2': "${listurl[2]}",
    'privilege':user.email,
    'vendorPhone':vendorPhone

  });
  print("Current Category ${productCategory.text.toString()}");
  for(int i=0; i<selectedCategoryList.length;i++){
    await productRef.push().set(<dynamic, dynamic> {

      'productName': productName.text.toString(),
      'firstLetter':productName.text.toString()[0],
      'productDescription': productDetail.text.toString(),
      'productPrice': int.parse(productPrice.text.toString()),
      'productCategory':selectedCategoryList[i],
      'image_0': "${listurl[0]}",
      'image_1': "${listurl[1]}",
      'image_2': "${listurl[2]}",
      'privilege':user.email,
      'vendorPhone':vendorPhone

    });}
  print("uploaded");
}

Widget ResuableRow(
    String name, TextEditingController controller, BuildContext context,String hint) {
  double textFieldWidth = MediaQuery.of(context).size.width * 0.5;
  double textWidth = MediaQuery.of(context).size.width * 0.3;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      Container(

        child: AutoSizeText(name,

            maxLines: 1,
            minFontSize: 16,
            style: TextStyle(
                color: fontWhite, fontWeight: FontWeight.w600)),
        width: textWidth,
      ),
      Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          shape: BoxShape.rectangle,

          // borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        width: textFieldWidth,
        height: 40,
        child: TextField(

          cursorColor: fontWhite,
          controller: controller,
          keyboardType: controller == productPrice
              ? TextInputType.number
              : TextInputType.text,
          style: TextStyle(color: fontWhite),
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              hoverColor: Colors.white10,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: TextStyle(color: hint != "Empty Field"? fontWhite: Colors.red)),
        ),
      ),

    ],
  );
}
final GlobalKey<ScaffoldState> _scaffoldkey=  GlobalKey<ScaffoldState>();

_showSnackBar(String content){
  final snackBar = SnackBar(
      content:Text(content),
      duration: Duration(seconds:2)
  );

  _scaffoldkey.currentState.showSnackBar(snackBar);

}