import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoApp());

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {
        _sliderValue = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  void _onSliderChanged(double value) {
    final newPosition = Duration(seconds: value.toInt());
    _controller.seekTo(newPosition);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _forward() {
    final newPosition = Duration(seconds: _controller.value.position.inSeconds + 10);
    _controller.seekTo(newPosition);
  }

  void _backward() {
    final newPosition = Duration(seconds: _controller.value.position.inSeconds - 10);
    _controller.seekTo(newPosition);
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? /*AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )*/  AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    /*Text(
                      '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                      style: TextStyle(color: Colors.white),
                    ),*/
                    Positioned(
                      bottom: 10,
                      child: Slider(
                        value: _sliderValue,
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        onChanged: _onSliderChanged,
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      child: IconButton(
                        icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _togglePlay,
                        iconSize: 50,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.replay_10),
                            iconSize: 50,
                            onPressed: _backward,
                            color: Colors.white,
                          ),
                          SizedBox(width: 100,),
                          IconButton(
                            icon: Icon(Icons.forward_10),
                            iconSize: 50,
                            onPressed: _forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}