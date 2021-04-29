import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/pages/menu_options.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.red,
);

class Navbar extends StatefulWidget {
  final List<MenuOption> options;
  final String currentRoute;
  final Function callback;
  const Navbar({this.options, this.currentRoute, this.callback});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  User currentUser;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<User>(
      stream: database.userReferenceStream(),
      builder: (context, snapshot) {
        currentUser = snapshot.data;
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
            height: size.height,
            width: 100.0,
            decoration: BoxDecoration(
              color: Color(0xff332A7C),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: size.height * 0.75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/wheelchair-01.png'),
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
                Positioned(
                  top: 30.0,
                  left: 30.0,
                  child: CustomText(
                    text: 'SWS',
                    weight: FontWeight.w100,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),
                Positioned(
                  top: 50.0,
                  child: CustomText(
                    text: currentUser != null
                        ? currentUser.email != null || currentUser.email != ''
                            ? currentUser.email
                            : "User's Email"
                        : "User's Email",
                    weight: FontWeight.w100,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),
                Positioned(
                  top: 150,
                  child: Column(
                    children: widget.options
                        .map(
                          (e) => NavBarItem(
                            text: e.title,
                            icon: e.icon,
                            selected: widget.currentRoute == e.route,
                            onTap: () => widget.callback(e),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final bool selected;
  NavBarItem({
    this.icon,
    this.text,
    this.onTap,
    this.selected,
  });
  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  AnimationController _controller1;
  AnimationController _controller2;

  Animation<double> _anim1;
  Animation<double> _anim2;
  Animation<double> _anim3;
  Animation<Color> _color;

  bool hovered = false;

  void animateChanges() {
    if (!widget.selected) {
      Future.delayed(Duration(milliseconds: 10), () {
        //_controller1.reverse();
      });
      _controller1.reverse();
      _controller2.reverse();
    } else {
      _controller1.forward();
      _controller2.forward();
      Future.delayed(Duration(milliseconds: 10), () {
        //_controller2.forward();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 275),
    );

    _anim1 = Tween(begin: 101.0, end: 75.0).animate(_controller1);
    _anim2 = Tween(begin: 101.0, end: 0.0).animate(_controller2);
    _anim3 = Tween(begin: 101.0, end: 25.0).animate(_controller2);
    _color = ColorTween(end: Color(0xff332a7c), begin: Colors.white)
        .animate(_controller2);

    _controller1.addListener(() {
      setState(() {});
    });
    _controller2.addListener(() {
      setState(() {});
    });

    animateChanges();
  }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    animateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          width: 101.0,
          color:
              hovered && !widget.selected ? Colors.white12 : Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  child: CustomPaint(
                    painter: CurvePainter(
                      value1: 0,
                      animValue1: _anim3.value,
                      animValue2: _anim2.value,
                      animValue3: _anim1.value,
                    ),
                  ),
                ),
              ),
              Container(
                height: 80.0,
                width: 101.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: _color.value,
                      size: 24.0,
                    ),
                    CustomText(
                      text: widget.text,
                      color: widget.selected ? Color(0xff332A7C) : Colors.white,
                      size: 16.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value1; // 200
  final double animValue1; // static value1 = 50.0
  final double animValue2; //static value1 = 75.0
  final double animValue3; //static value1 = 75.0

  CurvePainter({
    this.value1,
    this.animValue1,
    this.animValue2,
    this.animValue3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(101, value1);
    path.quadraticBezierTo(101, value1 + 10, animValue3, value1 + 10);
    path.lineTo(animValue1, value1 + 10);
    path.quadraticBezierTo(animValue2, value1 + 10, animValue2, value1 + 40);
    path.lineTo(101, value1 + 40);
    path.close();

    path.moveTo(101, value1 + 80);
    path.quadraticBezierTo(101, value1 + 70, animValue3, value1 + 70);
    path.lineTo(animValue1, value1 + 70);
    path.quadraticBezierTo(animValue2, value1 + 70, animValue2, value1 + 40);
    path.lineTo(101, value1 + 40);
    path.close();

    paint.color = Colors.white;
    paint.strokeWidth = 101.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
