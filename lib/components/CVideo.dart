import 'package:c_valide/app/Registry.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CVideoState();
}

class _CVideoState extends State<CVideo> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/guide.mp4')
      ..addListener(() {
        Registry.actualVideoDuration = _controller?.value?.position ?? Duration.zero;
      })
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 3 / 2, // _controller.value.aspectRatio,
//      autoPlay: true,
//      startAt: Registry.actualVideoDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController);
  }
}
