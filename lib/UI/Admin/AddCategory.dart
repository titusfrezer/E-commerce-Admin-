import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:loginui/UI/Admin/CategoriesList2.dart';
import 'package:loginui/UI/Admin/Post.dart';
import 'package:loginui/UI/Admin/Transaction.dart';
import 'package:loginui/UI/Admin/controlUser.dart';
import 'package:loginui/UI/Admin/todayTransaction.dart';
import 'package:loginui/auth_service.dart';
import 'package:loginui/variables/CategoriesList.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:loginui/variables/vars.dart';
import 'package:permission_handler/permission_handler.dart';
FirebaseAuth _auth;
FirebaseUser user;
var dir;
var files;
class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  //DatabaseReference productRef = FirebaseDatabase.instance.reference().child("catagory");
  var keys, data,connectivity;
  List<String> Data;
  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await (Connectivity().checkConnectivity());
    var testdir = await Directory('${dir.path}/Afroel');
    var fm = FileManager(root: Directory(testdir.path));
     files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/1/Android"],
        extensions: ["pdf"] //optional, to filter files, list only pdf files

    );
    print(files.length);
    print(user.email.toString());
  }
  void getPermission() async {
     dir = await getExternalStorageDirectory();
    print("getPermission");
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }
  void initState(){
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
     getPermission();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Afroel Admin",
            style: TextStyle(
                color: fontWhite, fontSize: 25, fontWeight: FontWeight.w600),
          ),
          backgroundColor: background_2,
        ),
        drawer: Drawer(

            child: ListView(
              children: <Widget>[
                Container(
                    child: FutureBuilder(
                        future: _auth.currentUser(),
                        builder: (context,AsyncSnapshot snapshot){
                          return ClipRect(
                            child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: ExactAssetImage(
                                            'assets/images/ecorp-lightblue.png'),
                                        fit: BoxFit.cover)),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                                  child: UserAccountsDrawerHeader(
                                    decoration:
                                    BoxDecoration(color: Colors.transparent),
                                    accountName: CircleAvatar(
                                        backgroundColor: background_2,
                                        foregroundColor: background,
                                        child: Text(user.email
                                            .substring(0, 1)
                                            .toUpperCase())),
                                    accountEmail: Text(
                                      user.email,
                                      style: TextStyle(
                                          color: background_2,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )),
                          );}
                    )
                ),
                InkWell(
                  child: ListTile(
                    title: Text('See Users'),
                    leading: Icon(
                      Icons.visibility,
                      color: background,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => controlUser()));
                  },
                ),
                InkWell(
                  child: ListTile(
                    title: Text('Post Digital documents'),
                    leading: Icon(
                      Icons.visibility,
                      color: background,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PostDigitalDocument()));
                  },
                ),
                InkWell(
                  child: ListTile(
                    title: Text('download Digital documents'),
                    leading: Icon(
                      Icons.visibility,
                      color: background,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FileDownloader()));
                  },
                ),
                InkWell(
                  child: ListTile(
                    title: Text('Transaction Requests'),
                    leading: Icon(Icons.swap_horiz, color: background),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => transaction()));
                  },
                ),
                InkWell(
                  child:ListTile(
                    title:Text('Filter Transaction Request'),
                    leading: Icon(Icons.today, color: background),
                  ),
                  onTap:(){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder:(context)=>todayTransaction())
                    );
                  }
                ),
                InkWell(
                  child: ListTile(
                    title: Text('My product List'),
                    leading: Icon(Icons.view_list, color: background),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesList2()));
                  },
                ),
                InkWell(
                  child: ListTile(
                    title: Text('Log out'),
                    leading: Icon(Icons.visibility_off, color: background),
                  ),
                  onTap: () {
                    AuthService().signOut();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
        ),
        backgroundColor: background_2,
        body: Container(
          child: Stack(
            //alignment: Alignment.center,
            children: <Widget>[
              Align(
               alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 460,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        decoration: BoxDecoration(
                          color: background_2,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25)),
                        ),
                        child: Text("Categories",
                            style: TextStyle(
                                color: fontWhite,
                                fontSize: fontHeader,
                                fontWeight: FontWeight.w500)),
                      ),
                      Expanded(child: CategoriesList())
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  //color: background,
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                  ),
                  child: RaisedButton(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, right: 15, left: 15),
                    color: Colors.white24,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Post()));
                      print("Category Created");
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Text("Add Category",
                        style: TextStyle(
                          color: fontWhite,
                          fontSize: 18,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class PostDigitalDocument extends StatelessWidget {
  final mainReference = FirebaseDatabase.instance.reference().child('DigitalDocument');
  Future getPdfAndUpload()async{
    var rng =  Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
    String fileName = '${randomName}.pdf';
//    print(fileName);
//    print('${file.readAsBytesSync()}');
    savePdf(file.readAsBytesSync(), fileName);
  }

  Future savePdf(List<int> asset, String name) async {

    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    documentFileUpload(url);
    return  url;
  }
  void documentFileUpload(String str) {

    var data = {
      "PDF": str,
    };
    mainReference.child("Documents").child('pdf').set(data).then((v) {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:RaisedButton(
        child: Text('File pick'),
        onPressed: (){
          getPdfAndUpload();
        },
      )
    );
  }
}
class FileDownloader extends StatelessWidget {
  var dio = Dio();

  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);

      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
Widget build(BuildContext context){

  return Scaffold(
      appBar: AppBar(
          title:Text("PDF File list from SD Card"),
          backgroundColor: Colors.redAccent
      ),
      body:files == null? Text("Searching Files"):
      ListView.builder(  //if file/folder list is grabbed, then show here
        itemCount: files?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              child:ListTile(
                title: Text(files[index].path.split('/').last),
                leading: Icon(Icons.picture_as_pdf),
                trailing: Icon(Icons.arrow_forward, color: Colors.redAccent,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ViewPDF(pathPDF:files[index].path.toString());
                    //open viewPDF page on click
                  }));
                },
              )
          );
        },
      )
  );
//     return Container(
//       child:RaisedButton(
//         child:Text('Download'),
//         onPressed: () async{
////           String path =
////           await ExtStorage.getExternalStoragePublicDirectory(
////               ExtStorage.DIRECTORY_DOWNLOADS);
//           var testdir;
//           var dir = await getExternalStorageDirectory();
//           bool checkDirectory= await Directory('${dir.path}/Afroel').exists();
//           if(!checkDirectory){
//            testdir = await Directory('${dir.path}/Afroel').create(recursive: true);
//
//           }
//           else{
//             testdir = await Directory('${dir.path}/Afroel');
//
//           }
//
//           //String fullPath = tempDir.path + "/boo2.pdf'";
//           String fullPath = "${testdir.path}/test.pdf";
//           print('full path is ${fullPath}');
//           List<FileSystemEntity> _files;
//           _files = testdir.listSync(recursive: true, followLinks: false);
//           print(_files);
//           var fm = FileManager(root: Directory(testdir.path));
//           var files = await fm.filesTree(
//               excludedPaths: ["/storage/emulated/1/Android"],
//               extensions: ["pdf"] //optional, to filter files, list only pdf files
//           );
//           print(files.length);
//           await download(dio, 'https://firebasestorage.googleapis.com/v0/b/e-commerce-571d5.appspot.com/o/56637073965850845979923069195869252305.pdf?alt=media&token=045dec96-8750-413c-9ab8-a524c9e42935', fullPath);
//         },
//       )
//     );
}
}
class ViewPDF extends StatelessWidget {
  String pathPDF = "";
  ViewPDF({this.pathPDF});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold( //view PDF
        appBar: AppBar(
          title: Text("Document"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        path: pathPDF
    );
  }
}