import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chime/features/video-call/presentation/view_model/video_state.dart';

class ChatMessagesWidget extends StatefulWidget {
  const ChatMessagesWidget({Key? key}) : super(key: key);

  @override
  State<ChatMessagesWidget> createState() => _ChatMessagesWidgetState();
}

class _ChatMessagesWidgetState extends State<ChatMessagesWidget> {
  final List<_ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to the bloc stream for new chat messages
    context.read<VideoBloc>().stream.listen((state) {
      if (state is ChatMessageReceivedState) {
        setState(() {
          _messages.add(
            _ChatMessage(fromUserId: state.fromUserId, message: state.message),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 250, // adjust height as needed
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(bottom: 60), // leave space for ChatInput
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child:
            _messages.isEmpty
                ? const Center(
                  child: Text(
                    'No messages yet.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return Align(
                      alignment:
                          msg.fromUserId == "self"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              msg.fromUserId == "self"
                                  ? Colors.blueAccent
                                  : Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.message,
                              style: const TextStyle(color: Colors.white),
                            ),
                            if (msg.fromUserId != "self")
                              Text(
                                msg.fromUserId,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white54,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}

class _ChatMessage {
  final String fromUserId;
  final String message;

  _ChatMessage({required this.fromUserId, required this.message});
}
