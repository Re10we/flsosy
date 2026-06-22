import 'package:equatable/equatable.dart';
import 'package:flsosy/data/models/chat_message_model.dart';

class ChatState extends Equatable {
  final List<ChatMessageModel> messages;
  final bool isTyping;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isTyping,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, error];
}
