import 'package:flutter/material.dart';
class Cart extends StatefulWidget {
  final String productTitle;
  final String productImage;
  final int productPrice;

  Cart(this.productTitle,this.productImage,this.productPrice,);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Cart')
      ) ,
      body:ListTile(
        title: Text(widget.productTitle),
        subtitle:Text(widget.productPrice.toString()) ,
        leading: FadeInImage(
          placeholder: AssetImage('assets/images/men1.jpeg'),
          image: NetworkImage(widget.productImage),
        ),
        trailing: IconButton(icon:Icon(Icons.check),onPressed: (){},),
      )
    );
  }
}
