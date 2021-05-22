import 'package:flutter/material.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/screens/auth/components/sigin_form.dart';
import 'package:sws_web/widgets/FadeAnimation.dart';
import 'package:sws_web/widgets/custom_scroll_behavior.dart';
import 'package:sws_web/widgets/custom_text.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({Key key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  double offset = 0;
  bool signinFormShown = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Animation<Offset> animateForm(double offset, bool show) {
    const int animationDuration = 1;
    const Offset offsetIn = Offset(1.575, 0.0);
    const Offset offsetOut = Offset(2.575, 0.0);

    if (offset > -100 && !show) {
      _controller = AnimationController(
        duration: const Duration(seconds: animationDuration),
        vsync: this,
      )..forward();

      _offsetAnimation = Tween<Offset>(
        begin: offsetOut,
        end: offsetIn,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ));

      setState(() {
        signinFormShown = true;
      });
    } else if (offset <= -100 && show) {
      _controller = AnimationController(
        duration: const Duration(seconds: animationDuration),
        vsync: this,
      )..forward();

      _offsetAnimation = Tween<Offset>(
        begin: offsetIn,
        end: offsetOut,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ));

      setState(() {
        signinFormShown = false;
      });
    }

    return _offsetAnimation;
  }

  int animateMobileForm() {
    int animate = -1;

    if (-.25 * offset > -100 && !signinFormShown) {
      animate = 1;

      setState(() {
        signinFormShown = true;
      });
    } else if (-.25 * offset <= -100 && signinFormShown) {
      animate = 0;

      setState(() {
        signinFormShown = false;
      });
    }

    return animate;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: NotificationListener<ScrollNotification>(
        onNotification: _updateOffsetAccordingToScroll,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: Stack(
            children: [
              Positioned(
                top: -.25 * offset,
                child: FadeAnimation(
                  0,
                  Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/bgnew.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: -.25 * offset,
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Align(
                      alignment: Alignment(-0.75, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400.withOpacity(.75)),
                            child: CustomText(
                              text: "Smart Wheelchair System",
                              size: !Responsive.isMobile(context) ? 48 : 24,
                              weight: FontWeight.bold,
                              color: kSecondaryColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade400.withOpacity(.75)),
                            child: CustomText(
                              text: "We care",
                              size: !Responsive.isMobile(context) ? 24 : 12,
                              color: kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height),
                    _buildInformationWidget(size),
                  ],
                ),
              ),
              !Responsive.isMobile(context)
                  ? SlideTransition(
                      position: animateForm(-.25 * offset, signinFormShown),
                      child: Container(
                        height: size.height,
                        width: Responsive.isDesktop(context) ? 750 : 500,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Center(child: SigninForm()),
                      ),
                    )
                  : Center(
                      child: FadeAnimation(
                        1.5,
                        Container(
                          height: 400,
                          width: 250,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Center(child: SigninForm()),
                        ),
                        fadeIn: animateMobileForm() == 1
                            ? true
                            : animateMobileForm() == 0
                                ? false
                                : signinFormShown,
                      ),
                    ),
              SizedBox(
                height: size.height,
                width: size.width,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: !Responsive.isMobile(context) ? 100 : 50,
                    width: size.width,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: size.height,
                width: size.width,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'images/logo_blue.png',
                    height: !Responsive.isMobile(context) ? 100 : 50,
                    width: !Responsive.isMobile(context) ? 100 : 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInformationWidget(Size size) => Container(
        padding: EdgeInsets.all(
            (!Responsive.isMobile(context) ? kMediumPadding : kDefaultPadding)),
        height: size.height - (!Responsive.isMobile(context) ? 100 : 50),
        width: size.width,
        color: kSecondaryColor,
        child: Column(
          mainAxisAlignment: Responsive.isMobile(context)
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: (!Responsive.isMobile(context)
                        ? kMediumPadding
                        : kDefaultPadding)),
                Text(
                  'Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: (!Responsive.isMobile(context) ? 48 : 24),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'This system is build to improve the hospital management and increase its efficiency.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: (!Responsive.isMobile(context) ? 28 : 14),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Responsive.isMobile(context) ? Container() : Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Acknowledgement',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: (!Responsive.isMobile(context) ? 48 : 24),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Gratitude to all that involve with the development.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: (!Responsive.isMobile(context) ? 28 : 14),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height: (!Responsive.isMobile(context)
                        ? kMediumPadding
                        : kDefaultPadding)),
                Responsive(
                  mobile: AcknowledgementCardGridView(
                    crossAxisCount: size.width < 650 ? 2 : 4,
                    childAspectRatio: size.width < 650 ? 1.3 : 1,
                  ),
                  tablet: AcknowledgementCardGridView(),
                  desktop: AcknowledgementCardGridView(
                    childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                  ),
                ),
              ],
            ),
            Responsive.isMobile(context)
                ? Container()
                : SizedBox(
                    height: (!Responsive.isMobile(context)
                        ? kMediumPadding
                        : kDefaultPadding)),
          ],
        ),
      );

  bool _updateOffsetAccordingToScroll(ScrollNotification scrollNotification) {
    double newOffset = scrollNotification.metrics.pixels;
    setState(() => offset = newOffset);
    return true;
  }
}

class Acknowledgement {
  final String asset;
  final String name;

  const Acknowledgement(this.name, this.asset);
}

final List<Acknowledgement> acknowledgements = [
  Acknowledgement('UTM-TDR Grant Vot No. 06G23', 'images/utm.png'),
  Acknowledgement('Grant Vot No. 5F117', 'images/logo-mohe.png'),
  Acknowledgement('Hospital Sultanah Aminah', 'images/hsa.gif'),
  Acknowledgement(
      'Software Engineering Research Group and Team', 'images/team.png')
];

class AcknowledgementCardGridView extends StatelessWidget {
  const AcknowledgementCardGridView({
    Key key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: acknowledgements.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: kDefaultPadding,
        mainAxisSpacing: kDefaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding * 0.75),
              height: (!Responsive.isMobile(context) ? 150 : 75),
              width: (!Responsive.isMobile(context) ? 300 : 150),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    acknowledgements[index].asset,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              acknowledgements[index].name,
              style: TextStyle(
                color: Colors.white54,
                fontSize: (!Responsive.isMobile(context) ? 28 : 8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
