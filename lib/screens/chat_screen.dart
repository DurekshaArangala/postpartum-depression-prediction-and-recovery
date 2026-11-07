import 'package:flutter/material.dart';

import '../theme/liyaa_theme.dart';
import '../widgets/ui.dart';

class _Msg {
  const _Msg({required this.me, required this.text});

  final bool me;
  final String text;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final input = TextEditingController();
  final scroll = ScrollController();
  bool typing = false;

  final List<_Msg> messages = [
    const _Msg(
      me: false,
      text: 'Hello 💜 I am Liya, a demo companion. How are you feeling today?',
    ),
  ];

  static const _suggestions = [
    'I am feeling tired',
    'I feel anxious',
    'I just need to talk',
  ];

  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      scroll.animateTo(
        scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> send([String? preset]) async {
    final value = (preset ?? input.text).trim();
    if (value.isEmpty || typing) return;

    setState(() {
      messages.add(_Msg(me: true, text: value));
      typing = true;
    });
    input.clear();
    _scrollToEnd();

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      typing = false;
      messages.add(
        const _Msg(
          me: false,
          text: 'Thank you for sharing. Your feelings matter. If you need '
              'support, consider speaking with someone you trust or a '
              'healthcare professional. This is a scripted demo, not a '
              'clinical chatbot.',
        ),
      );
    });
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final showSuggestions = messages.length == 1 && !typing;

    return LiyaaScaffold(
      appBar: const LiyaaAppBar('Liya • demo chat'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: scroll,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                children: [
                  for (final m in messages) _Bubble(msg: m),
                  if (typing) const _TypingBubble(),
                  if (showSuggestions)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final s in _suggestions)
                            ActionChip(
                              label: Text(s),
                              onPressed: () => send(s),
                              backgroundColor: LiyaaColors.plum,
                              side: const BorderSide(
                                color: Color(0x80F695C5),
                              ),
                              shape: const StadiumBorder(),
                              labelStyle: const TextStyle(
                                color: LiyaaColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: Container(
                padding: const EdgeInsets.only(left: 22, right: 6),
                decoration: BoxDecoration(
                  color: LiyaaColors.plum,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: LiyaaColors.shadow,
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: input,
                        onSubmitted: (_) => send(),
                        textInputAction: TextInputAction.send,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Your message…',
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    CircleIconButton(
                      icon: Icons.arrow_upward_rounded,
                      size: 48,
                      tooltip: 'Send',
                      onTap: () => send(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});

  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final me = msg.me;
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: me ? null : LiyaaColors.surface,
          gradient: me ? LiyaaColors.pinkGradient : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(me ? 22 : 6),
            bottomRight: Radius.circular(me ? 6 : 22),
          ),
          boxShadow: [
            BoxShadow(
              color: me ? LiyaaColors.glow : LiyaaColors.shadow,
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            fontWeight: me ? FontWeight.w600 : FontWeight.w400,
            color: me ? LiyaaColors.dark : LiyaaColors.ink,
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: LiyaaColors.surface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Text(
          '• • •',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 2,
            color: LiyaaColors.pink,
          ),
        ),
      ),
    );
  }
}