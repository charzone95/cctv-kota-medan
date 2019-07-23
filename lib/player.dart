import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import 'components/loading_indicator.dart';

class PlayerScreen extends StatefulWidget {
  final String title;
  final String url;

  const PlayerScreen({Key key, this.title, this.url}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController _controller;
  bool _isStarted = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _isStarted = true;

        setState(() {});
        _controller.play();
      }).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          if (mounted) {
            setState(() {
              _isError = true;
            });
          }
        },
      ).catchError((error) {
        setState(() {
          _isError = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    _isStarted = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
          child: _isError
              ? Text("Gagal memutar video")
              : _isStarted
                  ? PhotoView.customChild(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          SizedBox(height: 8.0),
                          Text("Anda dapat mencubit layar untuk memperbesar video"),
                        ],
                      ),
                      childSize: Size(
                          MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.width /
                              _controller.value.aspectRatio + 32.0),
                      minScale: 1.0,
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                    )
                  : CctvLoadingIndicator(),
        ),
      ),
    );
  }
}
