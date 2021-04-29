import 'package:flutter/material.dart';
import 'package:sws_web/constants/size.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';
import 'sign_in.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isLoading = false;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.indigo, Colors.lightBlueAccent.shade700],
        ),
      ),
      child: isLoading
          ? Loading()
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                height: size.height,
                width: size.width,
                child: Stack(
                  children: [
                    Container(
                      height: size.height,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: cDefaultPadding * 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "Smart Wheelchair System",
                                  size: 48,
                                  weight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                CustomText(
                                  text: "Bring to you care and independent",
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Container(
                              height: size.height * 0.75,
                              width: size.height * 0.75,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('/images/wheelchair-01.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: SignIn(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
