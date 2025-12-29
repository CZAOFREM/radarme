import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceReader extends StatefulWidget {
  const VoiceReader({super.key});

  @override
  State<VoiceReader> createState() => _VoiceReaderState();
}

class _VoiceReaderState extends State<VoiceReader> {
  late FlutterTts _flutterTts;
  bool _isPlaying = false;
  double _speechRate = 0.5;

  final String _articleText = 'This is the article text to be read aloud. It contains multiple sentences for demonstration purposes. The voice reader will highlight text as it is spoken.';

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() => _isPlaying = false);
    } else {
      await _flutterTts.speak(_articleText);
      setState(() => _isPlaying = true);
    }
  }

  void _setSpeechRate(double rate) {
    setState(() => _speechRate = rate);
    _flutterTts.setSpeechRate(rate);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Voice Reader',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                _articleText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[900],
            child: Column(
              children: [
                // Speed control
                Row(
                  children: [
                    const Text(
                      'Speed',
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Slider(
                        value: _speechRate,
                        min: 0.1,
                        max: 1.0,
                        onChanged: _setSpeechRate,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Play/Pause button
                Center(
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 64,
                      color: Colors.white,
                    ),
                    onPressed: _speak,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}