import 'package:flutter/material.dart';

class CctvLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 200.0,
          child: Image.asset("assets/img/logo_white.png"),
        ),
        Image.asset(
          "assets/img/loading_ellipsis.gif",
          height: 48.0,
          width: 100.0,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
