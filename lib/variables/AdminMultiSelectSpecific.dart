import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loginui/variables/vars.dart';

class AdminMultiSelectSpecific extends StatefulWidget {
  final categoryName;

  AdminMultiSelectSpecific(this.categoryName);
  @override
  _AdminMultiSelectSpecificState createState() => _AdminMultiSelectSpecificState();
}

class _AdminMultiSelectSpecificState extends State<AdminMultiSelectSpecific> {
  DatabaseReference productRef =
  FirebaseDatabase.instance.reference().child("catagory");
  Color background_2 = Color(0XFF738989);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: productRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            List myList = map.values.toList();
            for (int index = 0; index < myList.length; index++) {
              if (myList[index]["type"] == widget.categoryName) {
                myList.removeAt(index); // help to remove from the ui(to don't be duplicated)
              }
            }
            print(myList.length);

            return StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              padding: EdgeInsets.all(5),
              primary: false,
              itemCount: myList.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleCategory(myList[index]["type"],
                    myList[index]["image"], index, selectedCategoryList);
              },
              scrollDirection: Axis.vertical,
              staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
            );
          }
          return Center(
              child: SpinKitWave(
                size: 25,
                color: background_2,
                // controller: AnimationController(duration: Duration(seconds: 30), vs),
              ));
        });
  }
}

class SingleCategory extends StatefulWidget {
  final category;
  final image;
  final index;
  List selectedCategoryList;

  SingleCategory(
      this.category, this.image, this.index, this.selectedCategoryList);

  @override
  _SingleCategoryState createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white24,
        child: (_selectionMode)
            ? GridTile(
            header: GridTileBar(
              leading: Icon(
                _selectedIndexList.contains(widget.index)
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked,
                color: _selectedIndexList.contains(widget.index)
                    ? background_2
                    : Colors.black,
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_selectedIndexList.contains(widget.index)) {
                    _selectedIndexList.remove(widget.index);
                    widget.selectedCategoryList.remove(widget.category);
                  } else {
                    _selectedIndexList.add(widget.index);
                    widget.selectedCategoryList.add(widget.category);
                  }
                  _changeSelection(enable: false, index: -1);
                  print(widget.selectedCategoryList);
                });
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
                              image: NetworkImage(widget.image),
                              placeholder:
                              AssetImage('assets/images/cart.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ),
                  Text(
                    widget.category,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ))
            : GridTile(
          child: InkResponse(
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
                            image: NetworkImage(widget.image),
                            placeholder:
                            AssetImage('assets/images/cart.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                ),
                Text(
                  widget.category,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _changeSelection(enable: true, index: widget.index);
                widget.selectedCategoryList.add(widget.category);

                print(widget.selectedCategoryList);
              });
            },
          ),
        ));
  }
}
