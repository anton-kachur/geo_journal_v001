import "package:flutter/material.dart";
import 'dart:math';


class WelcomePage extends StatefulWidget {
  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween(begin: 50.0, end: 200.0).animate(controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) print("completed");
        else if (state == AnimationStatus.dismissed) print("dismissed");
      })
      ..addListener(() {
        print("value:${animation.value}");
        setState(() {});
      });
    controller.forward();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0.000001,
          backgroundColor: Colors.brown,
          title: Text('Welcome!', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                splashColor: Colors.transparent,
                icon: Icon(Icons.home_filled),
                onPressed: (){ Navigator.pushNamed(context, '/'); },
              )
            ]
        ),
      ),

      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                alignment: AlignmentDirectional.center,
                child: Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: Transform.rotate(
                    angle: -2 * pi * animation.value / 200,
                    child: Image.asset(
                      'assets/catalog-widget-placeholder.png',
                      fit: BoxFit.fitHeight,
                      width: animation.value,
                      height: animation.value,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}