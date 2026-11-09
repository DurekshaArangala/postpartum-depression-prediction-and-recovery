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
      text: 'Hello, I am Liya, a demo companion. How are you feeling today?',
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: LiyaaColors.pinkSoft,
              ),
              child: const LiyaaArt(
                'chat_avatar.png',
                fit: BoxFit.cover,
                fallbackIcon: Icons.favorite_rounded,
                iconSize: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liya',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Demo chat',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: LiyaaColors.plumSoft,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: LiyaaColors.pinkLight,
                              ),
                              shape: const StadiumBorder(),
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                color: LiyaaColors.plum,
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
                padding: const EdgeInsets.only(left: 20, right: 6),
                decoration: BoxDecoration(
                  color: LiyaaColors.blush,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: LiyaaColors.line, width: 1.2),
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
                          hintText: 'Type a message…',
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Material(
                      color: LiyaaColors.pink,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => send(),
                        child: const SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
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
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: me ? LiyaaColors.plum : LiyaaColors.pinkSoft,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(me ? 22 : 6),
            bottomRight: Radius.circular(me ? 6 : 22),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: 17,
            height: 1.35,
            color: me ? Colors.white : LiyaaColors.plum,
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
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: LiyaaColors.pinkSoft,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Text(
          '• • •',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            color: LiyaaColors.pink,
          ),
        ),
      ),
    );
  }
}