import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loginui/variables/vars.dart';
class SpecificCategoryList extends StatefulWidget {
  @override
  _SpecificCategoryListState createState() => _SpecificCategoryListState();
}

class _SpecificCategoryListState extends State<SpecificCategoryList> {
  Color background_2 = Color(0XFF738989);
  var categories = [
    {"Categories": "Fashion"},
    {"Categories": "Book"},
    {"Categories": "Food"},
    {"Categories": "Drinks"},
    {"Categories": "Household"},
    {"Categories": "Electronics"},
    {"Categories": "Women"},
    {"Categories": " Mother and children"},
    {"Categories": " Traditional cloth"},
    {"Categories": "Car"},
    {"Categories": "Utilities"},
    {"Categories": "Machinary"},
    {"Categories": "Stationary"},
    {"Categories": "Building materials"},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(scrollDirection: Axis.vertical,itemCount: categories.length,padding: EdgeInsets.all(5),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 4),
        itemBuilder: (BuildContext context, int index) {
          return SingleSpecificCategory(categories[index]['Categories']);
        });
  }
}

class SingleSpecificCategory extends StatelessWidget {
  final category;

  SingleSpecificCategory(this.category);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: background_2,
        child: InkWell(

            onTap: (){

            },
            child: new GridTile(


              child: Center(
                child: Text(category,   style: TextStyle(
                  color: fontWhite,
                  fontSize: 18,
                ),
                ),
              ),
            ))
    );
  }
}
