import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
Color background = Color(0XFFF7516C);
Color background_2 = Color(0XFF2A2629);
Color myGrey = Color(0XFFB1ABB5);
//Color background_2=Colors.brown;
Color fontWhite = Colors.white;
double appbarHeight = 200;
double appbarHeightSmaller = 75;
double carouselHeight = 275;
double fontHeader = 20;

TextEditingController productName = TextEditingController();
TextEditingController productDetail = TextEditingController();
TextEditingController productPrice = TextEditingController();
TextEditingController productCategory = TextEditingController();

String categoryHint = "Product Name";
String detailHint = "Product Detail";
String priceHint = "Product Price";
String addHint = "Add Category Name";

List<String> listurl = List();
List<String> selectedCategoryList = List();

var counter=0;
bool loading=false;
String postStatus;
//DatabaseReference productRef;
