import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:loginui/variables/cart.dart';
import 'package:loginui/variables/vars.dart';

class SingleProductDetail extends StatefulWidget {
  final String productImage_1;
  final String productImage_2;
  final String productImage_3;
  final String productImage_4;
  final String productTitle;
  final String productDescription;
  final String productCategory;
  final int productPrice;

  SingleProductDetail(
    this.productTitle,
    this.productDescription,
    this.productPrice,
    this.productCategory,
    this.productImage_1,
    this.productImage_2,
    this.productImage_3,
    this.productImage_4,
  );

  @override
  _SingleProductDetailState createState() => _SingleProductDetailState();
}

class _SingleProductDetailState extends State<SingleProductDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  height: carouselHeight,

                  child: Container(
                    height: carouselHeight,
                    child: Carousel(
                        borderRadius: true,
                        animationDuration: Duration(seconds: 3),
                        dotSize: 3,
                        dotColor: background_2,
                        boxFit: BoxFit.cover,
                        images: [
                          FadeInImage(
                            placeholder: AssetImage('assets/images/men1.jpeg'),
                            image: NetworkImage(widget.productImage_1),
                            fit: BoxFit.cover,
                          ),
                          FadeInImage(
                            placeholder: AssetImage('assets/images/men1.jpeg'),
                            image: NetworkImage(widget.productImage_2),
                            fit: BoxFit.cover,
                          ),
                          FadeInImage(
                            placeholder: AssetImage('assets/images/men1.jpeg'),
                            image: NetworkImage(widget.productImage_3),
                            fit: BoxFit.cover,
                          ),
//                        FadeInImage(
//                          placeholder: AssetImage('assets/images/men1.jpeg'),
//                          image: NetworkImage(widget.productImage_4),
//                          fit: BoxFit.cover,
//                        )
                        ]),
                  ),

                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 25,right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          //  padding: EdgeInsets.only(bottom: 5),
                          child:  Text(
                            widget.productTitle,
                            style: TextStyle(
                                fontSize: fontHeader, fontWeight: FontWeight.w600),

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: Text(
                            '${widget.productPrice.toString()} ETB',

                            style: TextStyle(
                                fontSize: fontHeader, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: Text(
                            "Product Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontHeader,
                                color: background_2),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    widget.productDescription,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey.shade500),
                                  ),
                                  alignment: Alignment.topLeft,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      alignment: Alignment.center,
                      height: 75,
                      child:  OutlineButton(
                        padding: EdgeInsets.only(left: 100,right: 100),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Cart(widget.productTitle,widget.productImage_1,widget.productPrice)));
                        },
                        child: Text(
                          "Buy Now",
                          style:
                          TextStyle(fontSize: fontHeader, color: background_2),
                        ),
                        color: Colors.white24,borderSide: BorderSide(color: background_2),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
