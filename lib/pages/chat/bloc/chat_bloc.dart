import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flsosy/data/models/chat_message_model.dart';
import 'package:flsosy/data/services/generative_ai_service.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required GenerativeAIService aiService})
      : _aiService = aiService,
        super(const ChatState()) {
    on<ChatMessageSent>(_onChatMessageSent);
  }

  final GenerativeAIService _aiService;

  Future<void> _onChatMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    final userMessage = ChatMessageModel(
      text: event.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message and set typing state
    emit(state.copyWith(
      messages: List.from(state.messages)..add(userMessage),
      isTyping: true,
      error: null,
    ));

    try {
      final responseText = await _aiService.sendMessage(event.text);

      final aiMessage = ChatMessageModel(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: List.from(state.messages)..add(aiMessage),
        isTyping: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isTyping: false,
        error: e.toString(),
      ));
    }
  }
}
