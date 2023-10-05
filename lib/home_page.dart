import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final SpeechToText speechToText = SpeechToText();
String lastWords = "";

  void initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult, partialResults: true);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      debugPrint(lastWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "A.L.L.E.N.",
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
        leading: const Icon(
          Icons.menu,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            startListening();
          } else if(speechToText.isListening) {
            stopListening();
          } else {
            initSpeech();
          }
        },
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: const Icon(Icons.mic),
      ),
    );
  }
}
