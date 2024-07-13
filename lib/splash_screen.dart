// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:web_view/main.dart';
//
//
// // ignore: camel_case_types
// class splashScreen extends StatefulWidget {
//   const splashScreen({super.key});
//
//   @override
//   _splashScreen createState() => _splashScreen();
// }
//
// class _splashScreen extends State<splashScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     Timer(
//       const Duration(seconds: 10),
//           () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const WebViewExample()
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: null,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//           child: Image.asset("assets/splash.mp4")),
//     );
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

import 'package:web_view/main.dart';

import 'loadingPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/splash.mp4");
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.play();
      _controller.setLooping(false);
    });

    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoadingPage()
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: VideoPlayer(_controller)),
      // FutureBuilder(
      //   future: _initializeVideoPlayerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return Center(
      //         child: SizedBox(
      //
      //           width: MediaQuery.of(context).size.width,
      //           child: AspectRatio(
      //             aspectRatio: _controller.value.aspectRatio,
      //             child: VideoPlayer(_controller),
      //           ),
      //         ),
      //       );
      //     } else {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
    );
  }
}
