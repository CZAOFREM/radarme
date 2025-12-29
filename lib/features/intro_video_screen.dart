import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasPlayed = false; // Placeholder for shared_preferences

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/intro.mp4')
      ..setVolume(0.0) // Silent-first
      ..addListener(_videoListener);

    await _controller.initialize();
    await _controller.play();

    // Fade in
    _animationController.forward();

    // Placeholder: check if played before
    if (_hasPlayed) {
      _navigateToNext();
    }
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      _fadeOutAndNavigate();
    }
  }

  void _skip() {
    _fadeOutAndNavigate();
  }

  void _fadeOutAndNavigate() {
    _animationController.reverse().then((_) {
      _navigateToNext();
    });
  }

  void _navigateToNext() {
    // Placeholder: check auth state
    bool isLoggedIn = false; // Placeholder
    String route = isLoggedIn ? '/home' : '/onboarding';
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      );
                    },
                  )
                : const CircularProgressIndicator(),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _skip,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}