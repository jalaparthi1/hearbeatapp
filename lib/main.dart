import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(HeartbeatApp());
}

class HeartbeatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeartbeatScreen(),
    );
  }
}

class HeartbeatScreen extends StatefulWidget {
  @override
  _HeartbeatScreenState createState() => _HeartbeatScreenState();
}

class _HeartbeatScreenState extends State<HeartbeatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _timerSeconds = 10;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 3));
  bool _isAudioPlaying = false;

  List<String> messages = [
    "Happy Valentine's Day!",
    "You are loved!",
    "Love is in the air!",
    "Forever and always!",
    "You make my heart skip a beat!"
  ];
  int messageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(_controller);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
          messageIndex = (_timerSeconds % messages.length);
        });
      } else {
        _confettiController.play();
        timer.cancel();
      }
    });
  }

  /// ✅ FIX: Play audio after user interaction
  Future<void> _playHeartbeatSound() async {
    try {
      if (!_isAudioPlaying) {
        await _audioPlayer.setSource(AssetSource('audio/Audio.mp3'));
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource('audio/Audio.mp3'));
        setState(() {
          _isAudioPlaying = true;
        });
        print("✅ Audio started successfully");
      }
    } catch (e) {
      print("❌ Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: GestureDetector(
        onTap: _playHeartbeatSound, // ✅ Play audio when the user taps
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 100,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _timerSeconds > 0 ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Text(
                      messages[messageIndex],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Timer: $_timerSeconds',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _playHeartbeatSound,
                    child: Text("Play Heartbeat ❤️"),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14,
                shouldLoop: false,
                colors: [Colors.red, Colors.pink, Colors.white],
                gravity: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
#fjutyiluo;lhilgkl;HandleUncaughtErrorHandler