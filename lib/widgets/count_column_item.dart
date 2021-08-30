import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountColumnItem extends StatefulWidget {
  String label;
  int total;

  CountColumnItem(this.total, this.label);

  @override
  _CountColumnItemState createState() => _CountColumnItemState();
}

class _CountColumnItemState extends State<CountColumnItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.total.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            widget.label,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
