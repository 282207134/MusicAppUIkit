import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
import '../core/music_store.dart';
import '../widgets/music_widgets.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});
  String _time(Duration value) =>
      '${value.inMinutes}:${(value.inSeconds % 60).toString().padLeft(2, '0')}';
  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    final song = store.currentSong;
    final favorite = store.favorites.contains(song.id);
    return AppPage(
      id: 'now_playing',
      title: 'Now Playing',
      action: IconButton(
        key: const ValueKey('favorite'),
        tooltip: favorite ? 'Remove favorite' : 'Add favorite',
        onPressed: () => store.toggleFavorite(song.id),
        icon: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          color: AppColors.pink,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 4, 32, 20),
              child: Column(
                children: [
                  Container(
                    height: (constraints.maxHeight * .46).clamp(220.0, 400.0),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 33),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.pink, AppColors.coral],
                      ),
                    ),
                    child: Artwork(
                      song.image,
                      radius: 14,
                      fit: song.image == 'player'
                          ? BoxFit.contain
                          : BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 27),
                  Text(
                    song.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Text(
                        _time(store.position),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                            activeTrackColor: AppColors.coral,
                            inactiveTrackColor: AppColors.surface,
                            thumbColor: AppColors.pink,
                          ),
                          child: Slider(
                            key: const ValueKey('playback_seek'),
                            value: store.duration.inMilliseconds > 0
                                ? (store.position.inMilliseconds /
                                          store.duration.inMilliseconds)
                                      .clamp(0, 1)
                                : 0,
                            onChanged: store.seek,
                          ),
                        ),
                      ),
                      Text(
                        _time(store.duration),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: 'Previous track',
                        onPressed: () => store.skip(-1),
                        icon: const Icon(Icons.skip_previous_rounded, size: 32),
                      ),
                      const SizedBox(width: 22),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.gradient,
                          boxShadow: [
                            BoxShadow(color: Color(0x44FF2464), blurRadius: 25),
                          ],
                        ),
                        child: IconButton(
                          key: const ValueKey('player_play'),
                          tooltip: store.playing
                              ? 'Pause preview'
                              : 'Play preview',
                          onPressed: store.togglePlayback,
                          icon: Icon(
                            store.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 22),
                      IconButton(
                        tooltip: 'Next track',
                        onPressed: () => store.skip(1),
                        icon: const Icon(Icons.skip_next_rounded, size: 32),
                      ),
                    ],
                  ),
                  if (store.playbackError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        store.playbackError!,
                        style: const TextStyle(
                          color: AppColors.pink,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  Text(
                    '30-second original preview',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF171717),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          key: const ValueKey('download_preview'),
                          tooltip: 'Save preview offline',
                          onPressed: () {
                            store.download(song.id);
                            notice(
                              context,
                              'Preview saved for offline listening.',
                            );
                          },
                          icon: Icon(
                            store.downloads.contains(song.id)
                                ? Icons.download_done
                                : Icons.download_rounded,
                            color: store.downloads.contains(song.id)
                                ? AppColors.pink
                                : Colors.white,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Copy track name',
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(
                                text: '${song.title} — ${song.artist}',
                              ),
                            );
                            if (context.mounted) {
                              notice(context, 'Track name copied.');
                            }
                          },
                          icon: const Icon(Icons.share, size: 22),
                        ),
                        IconButton(
                          tooltip: 'Toggle shuffle',
                          onPressed: store.toggleShuffle,
                          icon: Icon(
                            Icons.shuffle,
                            color: store.shuffle
                                ? AppColors.pink
                                : Colors.white,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Toggle repeat',
                          onPressed: store.toggleRepeat,
                          icon: Icon(
                            Icons.repeat,
                            color: store.repeat ? AppColors.pink : Colors.white,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Toggle sound',
                          onPressed: store.toggleMute,
                          icon: Icon(
                            store.muted ? Icons.volume_off : Icons.volume_up,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
