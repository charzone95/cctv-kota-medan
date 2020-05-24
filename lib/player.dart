import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _isStillWaiting = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _isStarted = true;

        if (this.mounted) {
          setState(() {});
          _controller.play();
        }
      }).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          if (this.mounted) {
            setState(() {
              _isError = true;
            });
          }
        },
      ).catchError((error) {
        if (this.mounted) {
          setState(() {
            _isError = true;
          });
        }
      });

    Future.delayed(Duration(seconds: 5), () {
      if (this.mounted) {
        setState(() {
          _isStillWaiting = true;
        });
      }
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
    void _showReportDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Laporkan Masalah"),
          content: Text(
              "Mohon laporkan masalah yang terjadi berkaitan aplikasi ini dengan menekan tombol di bawah ini. Terima kasih"),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                var phoneNumber = '+6285262379555';
                var message =
                    'Terjadi masalah saat memutar CCTV: ' + widget.title;
                var whatsappUrl =
                    "whatsapp://send?phone=$phoneNumber&text=$message";

                if (await canLaunch(whatsappUrl)) {
                  await launch(whatsappUrl);
                } else {
                  Fluttertoast.showToast(
                    msg:
                        "Gagal membuka WhatsApp. Pastikan WhatsApp telah terinstall.",
                  );
                }

                Navigator.of(context).pop();
              },
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.whatsapp),
                  SizedBox(width: 4.0),
                  Text("Lapor via Whatsapp"),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pantau CCTV",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.report_problem),
            onPressed: () {
              _showReportDialog();
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              _isError
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 60.0),
                        Text(
                          "Gagal memutar video",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 36.0),
                        OutlineButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.report_problem),
                              SizedBox(width: 4.0),
                              Text("Laporkan masalah"),
                            ],
                          ),
                          onPressed: () {
                            _showReportDialog();
                          },
                        ),
                      ],
                    )
                  : _isStarted
                      ? SizedBox(
                          height: 400.0,
                          child: PhotoView.customChild(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                    "Anda dapat mencubit layar untuk memperbesar video"),
                              ],
                            ),
                            childSize: Size(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.width /
                                        _controller.value.aspectRatio +
                                    32.0),
                            minScale: 1.0,
                            backgroundDecoration:
                                BoxDecoration(color: Colors.white),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CctvLoadingIndicator(),
                            SizedBox(height: 8.0),
                            _isStillWaiting
                                ? Text("Masih menunggu video dari server...")
                                : Container(),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
