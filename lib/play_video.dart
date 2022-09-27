import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class playVideo extends StatefulWidget {
  final String filePath, title, discrition, creator, category, location, date;

  const playVideo(
      {Key? key,
      required this.title,
      required this.filePath,
      required this.discrition,
      required this.creator,
      required this.category,
      required this.location,
      required this.date})
      : super(key: key);

  @override
  State<playVideo> createState() => _playVideoState();
}

class _playVideoState extends State<playVideo> {
  late VideoPlayerController controller;
  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.network(widget.filePath);
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 100, 99, 99),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          child: Column(children: [
        Expanded(
          child: AspectRatio(
            // aspectRatio: controller.value.aspectRatio,
            aspectRatio: 2 / 1,
            child: (Container(
                width: 300,
                height: 500,
                // alignment: Alignment.topCenter,
                child: VideoPlayer(controller))),
          ),
        ),
        Container(
          //duration of video
          child:
              Text("Total Duration: " + controller.value.duration.toString()),
        ),
        Container(
            child: VideoProgressIndicator(controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  backgroundColor: Colors.redAccent,
                  playedColor: Colors.green,
                  bufferedColor: Colors.purple,
                ))),
        Container(
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }

                    // setState(() {});
                  },
                  icon: Icon(controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow)),
              IconButton(
                  onPressed: () {
                    controller.seekTo(Duration(seconds: 0));

                    // setState(() {});
                  },
                  icon: Icon(Icons.stop))
            ],
          ),
        ),
        Text(
          'Title: ${widget.title}',
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 85, 94, 223)),
        ),
        const SizedBox(height: 5),
        Text(
          'Category: ${widget.category}',
          style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 1, 17)),
        ),
        const SizedBox(height: 5),
        Text(
          'Uploaded By: ${widget.creator}',
          style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 1, 17)),
        ),
        const SizedBox(height: 5),
        Text(
          'Location: ${widget.location}',
          style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 1, 17)),
        ),
        const SizedBox(height: 5),
        Text(
          'Date: ${widget.date}',
          style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 1, 17)),
        ),
        const SizedBox(height: 5),
        Text(
          'Discription:${widget.discrition}',
          style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 1, 17)),
        ),
        const SizedBox(height: 5),
      ])),
    );
  }
}
