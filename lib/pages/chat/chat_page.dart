import 'package:flsosy/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';
import 'widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.baseObsidianBlack,
      appBar: AppBar(
        backgroundColor: context.colors.baseObsidianBlack,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.strings?.sosy ?? 'Sosy',
          style: context.fonts.headlineLgMobile.copyWith(
            color: context.colors.accentNeonCyberGreen,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: context.colors.borderGreen,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) =>
                    WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToBottom(),
                ),
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 24.0,
                    ),
                    itemCount: state.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.messages.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.strings?.sosynAnalyzing ??
                                  'sosyn is analyzing the markets...',
                              style: context.fonts.bodySm.copyWith(
                                color: context.colors.neutralMutedSilverGray,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        );
                      }

                      final message = state.messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ChatBubble(
                          text: message.text,
                          isUser: message.isUser,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceBright,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: context.colors.borderGreen,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: context.fonts.bodyLg.copyWith(
                        color: context.colors.pureWhite,
                      ),
                      decoration: InputDecoration(
                        hintText: context.strings?.askSosynAboutTheMarkets ??
                            'Ask sosyn about the markets...',
                        hintStyle: context.fonts.bodyLg.copyWith(
                          color: context.colors.neutralMutedSilverGray,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),

                  /// Send button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: context.colors.accentNeonCyberGreen,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color: context.colors.baseObsidianBlack,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(ChatMessageSent(text));
      _textController.clear();
    }
  }
}
