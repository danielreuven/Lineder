import 'package:flutter/material.dart';
import 'package:lineder/helpers/locale.dart';
import 'package:lineder/newdatafirsttime/instrucation.dart';

class InformationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChooceInstrucation()),
          );
        },
        fillColor: Colors.blueAccent,
        splashColor: Colors.lightBlue,
        shape: StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
              Icon(Icons.info),
              const SizedBox(
                width: 8.0,
              ),
              PuleAnimation(
                child: Text(
                  "${DemoLocalizations.of(context).apptutorial}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}

class PuleAnimation extends StatefulWidget {
  final Widget child;

  const PuleAnimation({Key key, this.child}) : super(key: key);
  @override
  _PuleAnimationState createState() => _PuleAnimationState();
}

class _PuleAnimationState extends State<PuleAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: TweenAndBack(begin: 0.5, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
}

class TweenAndBack<T> extends Tween<T> {
  TweenAndBack({T begin, T end}) : super(begin: begin, end: end);

  @override
  T lerp(double t) {
    return super.lerp(t);
  }
}
