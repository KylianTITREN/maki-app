import 'package:flutter/material.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/components/card.dart';
import 'package:maki_app/components/header.dart';
import 'package:maki_app/components/skeleton.dart';
import 'package:maki_app/models/Video.dart';
import 'package:url_launcher/url_launcher.dart';

class VlogPage extends StatelessWidget {
  List<Video> _allVideos = Registry.allVideos;

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      menuIcon: true,
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 45),
          child: Column(
            children: <Widget>[
              CustomHeader(
                icon: '🎥',
                title: 'maki vlog',
              ),
              SizedBox(height: 50),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: _allVideos != null
                          ? _allVideos
                              .map(
                                (video) => Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: CustomCard(
                                    icon: video.icon,
                                    title: video.name,
                                    func: () => launch(video.url),
                                  ),
                                ),
                              )
                              .toList()
                          : [],
                    ),
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.9,
              //   height: 110 * Registry.allVideos.length.toDouble(),
              //   child: ListView.builder(
              //       itemCount: Registry.allVideos.length,
              //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //       itemBuilder: (BuildContext ctxt, int index) {
              //         return Padding(
              //           padding: const EdgeInsets.only(bottom: 30),
              //           child: new CustomCard(
              //               icon: Registry.allVideos[index].icon,
              //               title: Registry.allVideos[index].name,
              //               func: () => launch(Registry.allVideos[index].url)),
              //         );
              //       }),
              // ),
            ],
          )),
    );
  }
}
