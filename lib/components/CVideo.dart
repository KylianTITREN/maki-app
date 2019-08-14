import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CVideoState();
}

class _CVideoState extends State<CVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.0),
      child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
                child: Stack(
                  children: <Widget>[
                    VideoPlayer(_controller),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _controller.value.isPlaying ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
