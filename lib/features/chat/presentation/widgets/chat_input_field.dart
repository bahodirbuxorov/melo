
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconly/iconly.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

import '../../../chat/domain/entities/message_entity.dart';
import '../provider/message_provider.dart';
import 'package:melo/core/constants/app_sizes.dart';
import 'package:melo/core/theme/colors.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String chatId;
  final String senderId;

  const ChatInputField({
    super.key,
    required this.chatId,
    required this.senderId,
  });

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTyping);
  }

  void _onTyping() {
    _setTyping(true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _setTyping(false);
    });
  }

  Future<void> _setTyping(bool value) async {
    final doc = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('typing')
        .doc(widget.senderId);

    await doc.set({'isTyping': value}, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _controller.removeListener(_onTyping);
    _typingTimer?.cancel();
    _setTyping(false); // Chatdan chiqishda isTyping false
    _controller.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _sendText() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = MessageEntity(
      id: const Uuid().v4(),
      senderId: widget.senderId,
      text: text,
      sentAt: DateTime.now(),
    );

    await ref.read(messageRepoProvider).sendMessage(widget.chatId, message);
    _controller.clear();
    await _updateChat(message.text);
    await _setTyping(false);
  }

  Future<void> _updateChat(String lastMessage) async {
    await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'lastMessage': lastMessage,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) return;

    final dir = await getApplicationDocumentsDirectory();
    final audioPath = p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.m4a');

    await _recorder.start(const RecordConfig(), path: audioPath);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecordingAndSend() async {
    final audioPath = await _recorder.stop();
    setState(() => _isRecording = false);

    if (audioPath == null) return;
    final url = await _uploadFile(File(audioPath), 'voice_messages');

    final message = MessageEntity(
      id: const Uuid().v4(),
      senderId: widget.senderId,
      text: '[voice]',
      sentAt: DateTime.now(),
      isVoice: true,
      audioUrl: url,
    );

    await ref.read(messageRepoProvider).sendMessage(widget.chatId, message);
    await _updateChat('[voice]');
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final uploadedUrl = await _uploadFile(File(file.path), 'images');

    final message = MessageEntity(
      id: const Uuid().v4(),
      senderId: widget.senderId,
      text: '[image]',
      sentAt: DateTime.now(),
      mediaUrl: uploadedUrl,
      mediaType: 'image',
    );

    await ref.read(messageRepoProvider).sendMessage(widget.chatId, message);
    await _updateChat('[image]');
  }


  Future<String> _uploadFile(File file, String folder) async {
    final name = p.basename(file.path);
    final ref = FirebaseStorage.instance.ref().child('$folder/$name');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p12, vertical: Sizes.p8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : IconlyLight.voice, color: AppColors.grey),
            onPressed: _isRecording ? _stopRecordingAndSend : _startRecording,
          ),
          IconButton(
            icon: const Icon(IconlyLight.image, color: AppColors.grey),
            onPressed: _pickMedia,
          ),
          Expanded(
            child: TextField(
              enabled: !_isRecording,
              controller: _controller,
              style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
              decoration: InputDecoration(
                hintText: _isRecording ? "Yozilmoqda..." : "Xabar yozing...",
                hintStyle: TextStyle(color: AppColors.grey),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: Sizes.p12,
                  horizontal: Sizes.p16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: Sizes.p8),
          GestureDetector(
            onTap: _sendText,
            child: Container(
              padding: const EdgeInsets.all(Sizes.p12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(IconlyLight.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
