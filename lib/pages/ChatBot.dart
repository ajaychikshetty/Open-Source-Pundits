import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../bloc/chat_bloc.dart';
import '../const/AppColors.dart';
import '../const/LocalizationProvider.dart';
import '../widgets/ChatMessageModel.dart';
import 'package:provider/provider.dart';  // Import provider to listen to localization changes

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final ChatBloc chatBloc = ChatBloc();
  final TextEditingController textEditingController = TextEditingController();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  void _initTts() {
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              textEditingController.text = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 30),
          cancelOnError: true,
          partialResults: true,
        );
      }
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
  }

  Future<void> _speakText(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      setState(() {
        _isSpeaking = true;
      });
      await _flutterTts.speak(text);
    }
  }

  void _sendMessage() {
    if (textEditingController.text.isNotEmpty) {
      String text = textEditingController.text;
      textEditingController.clear();
      chatBloc.add(
        ChatGenerateNewTextMessageEvent(inputMessage: text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var strings = Provider.of<LocalizationProvider>(context).currentStrings;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        iconTheme: IconThemeData(
          color: AppColors.backgroundColor,
        ),
        title: Text(
          strings['chatBot']!,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.backgroundColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatSuccessState) {
            List<ChatMessageModel> messages = state.messages;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return _buildChatBubble(context, message);
                    },
                  ),
                ),
                if (chatBloc.generating)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                  ),
                _buildMessageInputArea(context),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatBubble(BuildContext context, ChatMessageModel message) {
    bool isUser = message.role == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.userMessageColor : AppColors.aiMessageColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isUser ? "You" : "AI Assistant",
                  style: TextStyle(
                    fontSize: 12,
                    color: isUser
                        ? AppColors.userNameColor
                        : AppColors.aiNameColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isUser)
                  IconButton(
                    icon: Icon(
                      _isSpeaking ? Icons.volume_up : Icons.volume_down,
                      color: AppColors.iconColor,
                      size: 20,
                    ),
                    onPressed: () => _speakText(message.parts.first.text),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message.parts.first.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: AppColors.hintTextColor),
                filled: true,
                fillColor: AppColors.inputFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening
                  ? AppColors.activeIconColor
                  : AppColors.inactiveIconColor,
            ),
            onPressed: _isListening ? _stopListening : _startListening,
          ),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.sendIconColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
