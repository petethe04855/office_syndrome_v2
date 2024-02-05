import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';
import 'package:video_player/video_player.dart';

class ProductVideo extends StatefulWidget {
  final ProductCategory productCategory;
  const ProductVideo({
    Key? key,
    required this.productCategory,
  }) : super(key: key);

  @override
  State<ProductVideo> createState() => _ProductVideoState();
}

class _ProductVideoState extends State<ProductVideo> {
  // late VideoPlayerController _videoControllers;
  // late bool _isPlaying;

  // int count = 0;

  // @override
  // void initState() {
  //   count++;
  //   print("Loading ${count}");

  //   super.initState();
  //   _videoControllers =
  //       VideoPlayerController.network(widget.productCategory.videoUrl)
  //         ..initialize().then((_) => setState(() {}));
  // }

  // void dispose() {
  //   super.dispose();
  //   _videoControllers.dispose();
  // }

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  // การเพิ่ม Listener สำหรับ _videoPlayerController เพื่อตรวจสอบว่าวิดีโอเล่นจบหรือไม่
  // ถ้าจบแล้วจะตั้งค่า _isPlaying เป็น false และเรียก setState เพื่อทำให้ UI ทำการ rebuild และปรับเปลี่ยนสถานะ.
  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.network(
      widget.productCategory.videoUrl,
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _toggleVideoPlayback() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
        _isPlaying = false;
      } else {
        _videoPlayerController.play();
        _isPlaying = true;
      }
    });
  }

  void _restartVideo() {
    _videoPlayerController.seekTo(Duration.zero);
    _videoPlayerController.play();
    setState(() {
      _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productCategory.categoryName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // _VideoPlayerList(_videoPlayerController),
              Container(
                height: 600,
                width: 400,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 24.0,
                    ),
                    onPressed: () {
                      _toggleVideoPlayback();
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _restartVideo,
                    icon: Icon(Icons.refresh),
                    label: Text('Restart'),
                  ),
                ],
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(widget.productCategory.description),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       // _videoControllers.value.isPlaying
      //       //     ? _videoControllers.pause()
      //       //     : _videoControllers.play();
      //     });
      //   },
      //   child: Icon(
      //       _videoControllers.value.isPlaying ? Icons.pause : Icons.play_arrow),
      // ),
    );
  }

  Widget _VideoPlayerList(VideoPlayerController videoController) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.6,
        width: MediaQuery.of(context).size.width / 1.5,
        child: videoController.value.isInitialized
            ? VideoPlayer(videoController)
            : Container(
                child: Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}
