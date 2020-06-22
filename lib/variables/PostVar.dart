class PostVar {
  String productName,productDescription,productCategory,image_0,image_1,image_2,image_3,privilege;
  int productPrice;
  var key;
  PostVar(

      this.productName,
      this.productDescription,
      this.productPrice,
      this.productCategory,
      this.image_0,
      this.image_1,
      this.image_2,
      this.privilege,
      this.key
      );

}
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:loginui/products.dart';
//import 'package:mock_data/mock_data.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
//
//
//
//  List<Asset> images = List<Asset>();
//  String _error = 'No Error Dectected';
//  DateTime myDate = DateTime.now();
//
//  Widget buildGridView() {
//    return GridView.count(
//      crossAxisSpacing: 10,
//      crossAxisCount: 4,
//      children: List.generate(images.length, (index) {
//        Asset asset = images[index];
//        return AssetThumb(
//          asset: asset,
//          width: 300,
//          height: 300,
//        );
//      }),
//    );
//  }
//
//  Future<void> loadAssets() async {
//    List<Asset> resultList = List<Asset>();
//    String error = 'No Error Dectected';
//
//    try {
//      resultList = await MultiImagePicker.pickImages(
//        maxImages: 4,
//        enableCamera: true,
//        selectedAssets: images,
//        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//        materialOptions: MaterialOptions(
//          actionBarColor: "#4E5050",
//          actionBarTitle: "Shopping App",
//          allViewTitle: "All Photos",
//          useDetailsView: false,
//          selectCircleStrokeColor: "#000000",
//        ),
//      );
//    } on Exception catch (e) {
//      error = e.toString();
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      images = resultList;
//      print(resultList);
//      _error = error;
//    });
//  }
//
//  upload(Asset Image)   async {
//    String fileName = mockString(50);
//    ByteData byteData = await Image.getByteData();
//    List<int> imageData = byteData.buffer.asUint8List();
//    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
//    StorageUploadTask uploadTask = ref.putData(imageData);
//
//    return await uploadTask.onComplete..ref.getDownloadURL();
//
//
//
////   {
////      'itemName' : itemName.text.toString(),
////      'itemPrice' : int.parse(itemprice.text),
////      'catagory'  : catValue
////      'imagename' : "Image$_imageName"
////    };
////    productRef.push(
////       'productRef'=> itemName.text,
////    );
//
//    // print(catValue);
//
//
//  }
//  uploadtoFirebase  (Asset Image_0,Asset Image_1,Asset Image_2,Asset Image_3)  {
//    upload(Image_0);
//    upload(Image_1);
//    upload(Image_2);
//    upload(Image_3);
//
//    print("successfully uploaded");
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return null;
//  }
//}
