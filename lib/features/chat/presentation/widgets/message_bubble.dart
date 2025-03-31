// message_bubble.dart
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melo/core/theme/colors.dart';
import 'package:melo/core/theme/text_styles.dart';
import 'full_img_view.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final bool isMine;
  final String time;
  final bool isVoice;
  final String? audioUrl;
  final String? mediaUrl;
  final String? mediaType;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMine,
    required this.time,
    this.isVoice = false,
    this.audioUrl,
    this.mediaUrl,
    this.mediaType,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  static AudioPlayer? _sharedPlayer;
  static VoidCallback? _stopOthers;

  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  bool get _isPlaying => _player.playing;

  @override
  void initState() {
    super.initState();

    _player.positionStream.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });

    _player.durationStream.listen((d) {
      if (mounted && d != null) setState(() => _duration = d);
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
        if (mounted) setState(() => _position = Duration.zero);
      }
    });
  }

  Future<void> _playPause() async {
    if (widget.audioUrl == null) return;

    if (_isPlaying) {
      await _player.pause();
    } else {
      _stopOthers?.call();

      if (_sharedPlayer != _player) {
        await _player.setUrl(widget.audioUrl!);
        _sharedPlayer = _player;
        _stopOthers = () {
          _sharedPlayer?.pause();
          _sharedPlayer?.seek(Duration.zero);
        };
      }

      await _player.play();
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.isMine
        ? AppColors.primary
        : isDark
        ? AppColors.darkCard
        : AppColors.lightCard;
    final textColor = widget.isMine
        ? Colors.white
        : isDark
        ? AppColors.darkText
        : AppColors.lightText;

    return Align(
      alignment: widget.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(widget.isMine ? 16 : 0),
            bottomRight: Radius.circular(widget.isMine ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (widget.mediaType == 'image' && widget.mediaUrl != null) ...[
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullImageScreen(imageUrl: widget.mediaUrl!),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    widget.mediaUrl!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ]
            else if (widget.isVoice && widget.audioUrl != null) ...[
              Row(
                children: [
                  IconButton(
                    onPressed: _playPause,
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : IconlyBold.play,
                      size: 30,
                      color: textColor,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1,
                      value: _position.inMilliseconds
                          .clamp(0, _duration.inMilliseconds)
                          .toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(_position),
                    style: AppTextStyles.labelSmall(context).copyWith(color: textColor),
                  ),
                ],
              ),
            ] else ...[
              Text(
                widget.text,
                style: AppTextStyles.bodySmall(context).copyWith(color: textColor),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              widget.time,
              style: AppTextStyles.labelSmall(context).copyWith(
                color: widget.isMine ? Colors.white70 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}