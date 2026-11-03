import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../data/local_settings.dart';

class MusicStore extends ChangeNotifier {
  MusicStore({this.settings, this.audioEnabled = true});
  final LocalSettings? settings;
  final bool audioEnabled;
  final Set<String> favorites = {}, downloads = {};
  final Set<String> followed = artists.map((a) => a.name).toSet();
  Song currentSong = featuredSong;
  List<Song> queue = [featuredSong, ...playlistSongs];
  String name = 'Jessica Rae',
      email = 'jessicarae@gmail.com',
      language = 'American English';
  bool signedIn = false, notifications = true;
  bool rememberSession = true;
  bool playing = false, shuffle = false, repeat = false, muted = false;
  Duration position = Duration.zero, duration = const Duration(seconds: 30);
  String? playbackError;
  AudioPlayer? _player;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  Future<void> restore() async {
    final raw = await settings?.read('music_ui');
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      name = data['name'] as String? ?? name;
      email = data['email'] as String? ?? email;
      language = data['language'] as String? ?? language;
      signedIn = data['signedIn'] as bool? ?? false;
      notifications = data['notifications'] as bool? ?? true;
      for (final entry in [
        (favorites, 'favorites'),
        (followed, 'followed'),
        (downloads, 'downloads'),
      ]) {
        if (data[entry.$2] is List) {
          entry.$1
            ..clear()
            ..addAll((data[entry.$2] as List).whereType<String>());
        }
      }
    } on FormatException {
      /* Keep defaults for a damaged preference record. */
    }
  }

  Future<void> _save() async {
    await settings?.write(
      'music_ui',
      jsonEncode({
        'name': name,
        'email': email,
        'language': language,
        'signedIn': signedIn && rememberSession,
        'notifications': notifications,
        'favorites': favorites.toList(),
        'followed': followed.toList(),
        'downloads': downloads.toList(),
      }),
    );
  }

  void _changed() {
    notifyListeners();
    unawaited(_save());
  }

  void toggleFavorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    _changed();
  }

  void toggleFollow(String artist) {
    followed.contains(artist) ? followed.remove(artist) : followed.add(artist);
    _changed();
  }

  void download(String id) {
    downloads.add(id);
    _changed();
  }

  void setLanguage(String value) {
    language = value;
    _changed();
  }

  void setNotifications(bool value) {
    notifications = value;
    _changed();
  }

  void signIn(String value, {String? username, bool remember = true}) {
    email = value;
    rememberSession = remember;
    if (username != null && username.trim().isNotEmpty) name = username.trim();
    signedIn = true;
    _changed();
  }

  void updateName(String value) {
    name = value.trim();
    _changed();
  }

  Future<void> saveFeedback(String value) async {
    await settings?.write('feedback', value);
  }

  Future<void> signOut() async {
    await _player?.pause();
    playing = false;
    signedIn = false;
    _changed();
  }

  AudioPlayer _audio() {
    if (_player != null) return _player!;
    final player = _player = AudioPlayer();
    _subscriptions.addAll([
      player.onPositionChanged.listen((value) {
        position = value;
        notifyListeners();
      }),
      player.onDurationChanged.listen((value) {
        duration = value;
        notifyListeners();
      }),
      player.onPlayerStateChanged.listen((value) {
        playing = value == PlayerState.playing;
        notifyListeners();
      }),
      player.onPlayerComplete.listen((_) {
        position = Duration.zero;
        playing = false;
        notifyListeners();
      }),
    ]);
    return player;
  }

  Future<void> playSong(Song song) async {
    currentSong = song;
    position = Duration.zero;
    playbackError = null;
    if (!audioEnabled) {
      playing = true;
      notifyListeners();
      return;
    }
    try {
      final player = _audio();
      await player.setReleaseMode(repeat ? ReleaseMode.loop : ReleaseMode.stop);
      await player.play(
        AssetSource('audio/preview.wav'),
        volume: muted ? 0 : .55,
      );
    } catch (_) {
      playing = false;
      playbackError = 'Preview could not be played. Please try again.';
    }
    notifyListeners();
  }

  Future<void> togglePlayback() async {
    if (!audioEnabled) {
      playing = !playing;
      notifyListeners();
      return;
    }
    try {
      if (_player == null || (!playing && position == Duration.zero)) {
        await playSong(currentSong);
      } else if (playing) {
        await _player!.pause();
      } else {
        await _player!.resume();
      }
    } catch (_) {
      playbackError = 'Preview could not be played. Please try again.';
      notifyListeners();
    }
  }

  Future<void> seek(double fraction) async {
    position = Duration(
      milliseconds: (duration.inMilliseconds * fraction.clamp(0, 1)).round(),
    );
    if (audioEnabled && _player != null) await _player!.seek(position);
    notifyListeners();
  }

  Future<void> skip(int direction) async {
    final index = queue.indexWhere((song) => song.id == currentSong.id);
    final next = shuffle
        ? Random().nextInt(queue.length)
        : (index + direction) % queue.length;
    await playSong(queue[next]);
  }

  void toggleShuffle() {
    shuffle = !shuffle;
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    repeat = !repeat;
    await _player?.setReleaseMode(repeat ? ReleaseMode.loop : ReleaseMode.stop);
    notifyListeners();
  }

  Future<void> toggleMute() async {
    muted = !muted;
    await _player?.setVolume(muted ? 0 : .55);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    unawaited(_player?.dispose());
    super.dispose();
  }
}

class MusicScope extends InheritedNotifier<MusicStore> {
  const MusicScope({super.key, required MusicStore store, required super.child})
    : super(notifier: store);
  static MusicStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MusicScope>()!.notifier!;
}
