import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconly/iconly.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../chat/domain/entities/message_entity.dart';
import '../provider/message_provider.dart';
import 'package:melo/core/constants/app_sizes.dart';
import 'package:melo/core/theme/colors.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String chatId;
  final String senderId;

  const ChatInputField({super.key, required this.chatId, required this.senderId});

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final url = await _uploadFile(file, 'files');

    final message = MessageEntity(
      id: const Uuid().v4(),
      senderId: widget.senderId,
      text: '[file] ${result.files.single.name}',
      sentAt: DateTime.now(),
      mediaUrl: url,
      mediaType: 'file',
    );

    await ref.read(messageRepoProvider).sendMessage(widget.chatId, message);
    await _updateChat('[file]');
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
        color: isDark ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : IconlyLight.voice, color: Colors.grey),
            onPressed: _isRecording ? _stopRecordingAndSend : _startRecording,
          ),
          IconButton(
            icon: const Icon(IconlyLight.image, color: Colors.grey),
            onPressed: _pickMedia,
          ),

          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Xabar yozing...${_isRecording ? " (Yozilmoqda...)" : ""}',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: isDark ? Colors.white12 : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: Sizes.p12,
                  horizontal: Sizes.p16,
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
