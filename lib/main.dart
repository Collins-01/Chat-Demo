import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/views/splash_screen_view.dart';

import 'navigations/navigations.dart';

void main() {
  setUpLocaator();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HARMONY CHAT DEMO',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreenView(),

      // Scaffold(
      //   body: SafeArea(
      //     child: Column(
      //       children: [
      //         Row(
      //           children: [
      //             Expanded(
      //               child: BubbleNormalAudio(
      //                 isSender: true,
      //                 color: const Color(0xFFE8E8EE),
      //                 // position: model.position,
      //                 // isPlaying: model.isPlaying,
      //                 isLoading: true,
      //                 // isPause: !model.isPlaying,
      //                 onSeekChanged: (value) {},
      //                 onPlayPauseButtonClick: () {
      //                   // model.setCurrentAudioId(message.localId);
      //                   // model.playAudio(message.localMediaPath!);
      //                 },
      //                 sent: true,
      //                 delivered: false,
      //                 seen: true,
      //                 tail: true,
      //               ),
      //             ),
      //             IconButton(
      //                 onPressed: () {},
      //                 icon: const Icon(
      //                   Icons.error_outline_outlined,
      //                   color: Colors.red,
      //                 ))
      //           ],
      //         ),
      //         BubbleNormalAudio(
      //           isSender: false,
      //           color: const Color(0xFFE8E8EE),

      //           // position: model.position,
      //           // isPlaying: model.isPlaying,
      //           isLoading: false,
      //           // isPause: !model.isPlaying,
      //           onSeekChanged: (value) {},
      //           onPlayPauseButtonClick: () {
      //             // model.setCurrentAudioId(message.localId);
      //             // model.playAudio(message.localMediaPath!);
      //           },
      //           sent: true,
      //           delivered: false,
      //           seen: true,
      //           tail: true,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      navigatorKey: NavigationService.instance.navigatorKey,
      onGenerateRoute: RouteGenerators.generateRoutes,
    );
  }
}
