import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/info.png",
            height: 30,
            width: 30,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/menu.png",
            height: 30,
            width: 30,
          ),
        ),
      ],
    );
  }
}
