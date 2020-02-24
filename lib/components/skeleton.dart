import 'package:flutter/material.dart';
import 'package:maki_app/components/text-semibold.dart';
import 'package:maki_app/res/HeroTags.dart';
import 'package:maki_app/utils/Page.dart';

class SkeletonPage extends StatelessWidget {
  SkeletonPage({this.child, this.menuIcon});

  final Widget child;
  final bool menuIcon;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          bottomNavigationBar: Hero(
            tag: HeroTags.bottom,
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Colors.transparent,
                transform: Matrix4.translationValues(
                    0.0, MediaQuery.of(context).padding.bottom, 0.0),
                height: 105,
                child: Image.asset('assets/images/wave.png', fit: BoxFit.cover),
              ),
            ),
          ),
          appBar: AppBar(
           automaticallyImplyLeading: false, // Don't show the leading button
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                menuIcon != true
                    ? Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0),
                        child: TextSemiBold(
                          text: 'MAKI APP',
                        ))
                    : Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0),
                        child: GestureDetector(
                            onTap: () {
                              quitPage(context);
                            },
                            child: Image.asset('assets/images/left-arrow.png',width: 30,)),
                      ),
              ],
            ),
            actions: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(right: 25),
                child: Hero(
                  tag: HeroTags.logo,
                  child: Material(
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/images/maki-shadow.png',
                      width: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: child,
        ),
      ),
    );
  }
}
