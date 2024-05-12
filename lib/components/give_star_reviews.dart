// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyGiveStarReviews extends StatelessWidget {
  final List<MyGiveStarData> starData;
  final double spaceBetween;

  MyGiveStarReviews({required this.starData, this.spaceBetween = 17.0});

  @override
  Widget build(BuildContext context) {
    return _createList(this.starData, this.spaceBetween);
  }

  Widget _createList(List<MyGiveStarData> list, double space) {
    List<Widget> tmp = <Widget>[];

    for (var x in list) {
      tmp.add(Row(
        children: <Widget>[
          Text(
            x.text,
            style: x.textStyle ?? TextStyle(fontSize: 16),
          ),
          MyStarRating(
            value: x.value,
            starCount: x.starCount,
            onChanged: x.onChanged,
            filledStar: x.filledStar,
            unfilledStar: x.unfilledStar,
            size: x.size,
            spaceBetween: x.spaceBetween,
            activeStarColor: x.activeStarColor,
            inactiveStarColor: x.inactiveStarColor,
          ),
        ],
      ));
    }

    return Column(
        children: List.generate(list.length + list.length, (i) {
      if (i % 2 == 0) {
        return SizedBox(
          height: 0,
        );
      }

      return tmp[i ~/ 2];
    }));
  }
}

class MyStarRating extends StatefulWidget {
  final void Function(int index)? onChanged;
  final int? value;
  final IconData? filledStar;
  final IconData? unfilledStar;
  final int starCount;
  final double size;
  final double spaceBetween;
  final Color activeStarColor;
  final Color inactiveStarColor;

  MyStarRating(
      {Key? key,
      this.onChanged,
      this.value = 0,
      this.starCount = 5,
      this.filledStar,
      this.unfilledStar,
      this.spaceBetween = 5,
      this.size = 25,
      this.activeStarColor = const Color(0xffffd900),
      this.inactiveStarColor = Colors.black54})
      : assert(value != null),
        super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<MyStarRating> {
  late int value;

  @override
  void initState() {
    value = widget.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.starCount, (index) {
        return GestureDetector(
          onTap: () {
            if (widget.onChanged != null) {
              setState(() {
                value = value == index + 1 ? index : index + 1;
              });
              widget.onChanged!.call(value);
            }
          },
          child: Icon(
            index < value
                ? widget.filledStar ?? Icons.star
                : widget.unfilledStar ?? Icons.star_border,
            color: index < value
                ? widget.activeStarColor
                : widget.inactiveStarColor,
            size: widget.size,
          ),
        );
      }),
    );
  }
}

class MyGiveStarData {
  final String text;
  final TextStyle? textStyle;
  final void Function(int index)? onChanged;
  final int value;
  final int starCount;
  final IconData? filledStar;
  final IconData? unfilledStar;
  final double size;
  final double spaceBetween;
  final Color activeStarColor;
  final Color inactiveStarColor;

  MyGiveStarData(
      {required this.text,
      this.onChanged,
      this.textStyle,
      this.value = 0,
      this.starCount = 5,
      this.filledStar,
      this.unfilledStar,
      this.size = 25,
      this.spaceBetween = 5,
      this.activeStarColor = const Color(0xffffd900),
      this.inactiveStarColor = Colors.black54});
}
