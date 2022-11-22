import 'package:flutter/material.dart';
import 'package:allojobstogo/utils/constants.dart';

class HeaderWidget extends StatelessWidget {
  final double height;

  const HeaderWidget({Key? key, required this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        height: height,
        color: Constants.primaryColor,
        child: Center(
          child: Container(
            width: 300,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80.0,
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                width: 150.0,
                height: 150.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoLogoHeaderWidget extends StatelessWidget {
  final double height;

  const NoLogoHeaderWidget({Key? key, required this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        height: height,
        color: Constants.primaryColor,
        child: Center(
          child: Container(
            width: 200,
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 150);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
