import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/music_store.dart';
import '../data/catalog.dart';

void notice(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

void goHome(BuildContext context) =>
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);

Future<void> openSong(
  BuildContext context,
  Song song, {
  List<Song>? queue,
}) async {
  final store = MusicScope.of(context);
  store.queue = queue ?? [song, ...playlistSongs.where((s) => s.id != song.id)];
  await store.playSong(song);
  if (context.mounted) Navigator.pushNamed(context, '/now_playing');
}

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.id,
    required this.child,
    this.title,
    this.action,
    this.footer,
    this.navIndex,
  });
  final String id;
  final String? title;
  final Widget child;
  final Widget? action, footer;
  final int? navIndex;
  @override
  Widget build(BuildContext context) => Scaffold(
    key: ValueKey('screen_$id'),
    extendBody: navIndex != null,
    bottomNavigationBar: navIndex == null
        ? null
        : MusicNavigation(index: navIndex!),
    body: SafeArea(
      bottom: navIndex == null,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              if (title != null)
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        IconButton(
                          key: const ValueKey('back'),
                          tooltip: 'Back',
                          icon: const Icon(Icons.chevron_left, size: 27),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              goHome(context);
                            }
                          },
                        ),
                        Expanded(
                          child: Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 48, child: action),
                      ],
                    ),
                  ),
                ),
              Expanded(child: child),
              if (footer != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 28),
                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 60,
    this.width,
    this.fontSize = 16,
  });
  final String label;
  final VoidCallback? onPressed;
  final double height, fontSize;
  final double? width;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
    child: Opacity(
      opacity: onPressed == null ? .45 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(height > 40 ? 12 : 6),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(gradient: AppColors.gradient),
          child: InkWell(
            onTap: onPressed,
            child: SizedBox(
              height: height,
              width: width ?? double.infinity,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class Artwork extends StatelessWidget {
  const Artwork(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.radius = 6,
    this.fit = BoxFit.cover,
  });
  final String asset;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/$asset.png',
      width: width,
      height: height,
      fit: fit,
      excludeFromSemantics: true,
    ),
  );
}

class MusicNavigation extends StatelessWidget {
  const MusicNavigation({super.key, required this.index});
  final int index;
  static const items = <(IconData, String, String)>[
    (Icons.home_rounded, 'Home', '/home'),
    (Icons.album_rounded, 'Album', '/upcoming'),
    (Icons.music_note_rounded, 'My Music', '/music'),
    (Icons.person_rounded, 'Profile', '/profile'),
  ];
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      height: 82,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .88),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(
          items.length,
          (i) => Expanded(
            child: Semantics(
              selected: i == index,
              child: InkWell(
                key: ValueKey('nav_$i'),
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  if (i != index) {
                    Navigator.pushReplacementNamed(context, items[i].$3);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[i].$1,
                      size: 30,
                      color: i == index ? AppColors.pink : Colors.white,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i].$2,
                      style: TextStyle(
                        fontSize: 13,
                        color: i == index ? AppColors.pink : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.onViewAll});
  final String title;
  final VoidCallback? onViewAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (onViewAll != null)
          GradientButton(
            label: 'View All',
            onPressed: onViewAll,
            height: 28,
            width: 78,
            fontSize: 13,
          ),
      ],
    ),
  );
}

class Greeting extends StatelessWidget {
  const Greeting({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hello', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              MusicScope.of(context).name == 'Jessica Rae'
                  ? 'John Johnson'
                  : MusicScope.of(context).name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      InkWell(
        key: const ValueKey('open_profile'),
        onTap: () => Navigator.pushNamed(context, '/profile'),
        child: const Artwork('avatar', width: 48, height: 48, radius: 0),
      ),
    ],
  );
}

class CatalogSearch extends StatelessWidget {
  const CatalogSearch({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          key: const ValueKey('catalog_search'),
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: 'Search album, song...',
            prefixIcon: Icon(Icons.search, color: AppColors.muted),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 60,
          width: 58,
          child: IconButton(
            key: const ValueKey('open_categories'),
            tooltip: 'Browse categories',
            icon: const Icon(Icons.tune, color: AppColors.muted),
            onPressed: () => Navigator.pushNamed(context, '/categories'),
          ),
        ),
      ),
    ],
  );
}

class SongTile extends StatelessWidget {
  const SongTile(
    this.song, {
    super.key,
    this.showPrice = false,
    this.compact = false,
    this.queue,
  });
  final Song song;
  final bool showPrice, compact;
  final List<Song>? queue;
  @override
  Widget build(BuildContext context) {
    final selected = MusicScope.of(context).currentSong.id == song.id;
    return InkWell(
      key: ValueKey('song_${song.id}'),
      onTap: () => openSong(context, song, queue: queue),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: compact ? 10 : 10),
        child: Row(
          children: [
            Artwork(song.image, width: 70, height: 70),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: selected ? AppColors.pink : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (showPrice)
              SizedBox(
                width: 70,
                child: selected || song.id == 'perfect' || song.id == 'again'
                    ? GradientButton(
                        label: '\$${song.price}',
                        fontSize: 12,
                        height: 32,
                        onPressed: () => Navigator.pushNamed(context, '/cards'),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF202020),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/cards'),
                        child: Text(
                          '\$${song.price}',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
              )
            else
              IconButton(
                tooltip: 'Track options',
                icon: const Icon(Icons.more_vert, size: 21),
                onPressed: () => trackOptions(context, song),
              ),
          ],
        ),
      ),
    );
  }
}

void trackOptions(
  BuildContext context,
  Song song,
) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: AppColors.surface,
  showDragHandle: true,
  builder: (sheetContext) {
    final store = MusicScope.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(song.title), subtitle: Text(song.artist)),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: Text(
              store.favorites.contains(song.id)
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
            onTap: () {
              store.toggleFavorite(song.id);
              Navigator.pop(sheetContext);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Save preview offline'),
            onTap: () {
              store.download(song.id);
              Navigator.pop(sheetContext);
              notice(context, 'Preview saved. Available offline in My Music.');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('View artist'),
            onTap: () {
              Navigator.pop(sheetContext);
              Navigator.pushNamed(context, '/artist', arguments: song.artist);
            },
          ),
        ],
      ),
    );
  },
);

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/now_playing'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                children: [
                  Artwork(
                    store.currentSong.image,
                    width: 35,
                    height: 40,
                    radius: 3,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.currentSong.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          store.currentSong.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Previous track',
                    onPressed: () => store.skip(-1),
                    icon: const Icon(Icons.skip_previous, size: 22),
                  ),
                  IconButton(
                    key: const ValueKey('mini_play'),
                    tooltip: store.playing ? 'Pause' : 'Play',
                    onPressed: store.togglePlayback,
                    icon: Icon(
                      store.playing ? Icons.pause : Icons.play_arrow,
                      size: 22,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next track',
                    onPressed: () => store.skip(1),
                    icon: const Icon(Icons.skip_next, size: 22),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: store.duration.inMilliseconds > 0
                  ? (store.position.inMilliseconds /
                            store.duration.inMilliseconds)
                        .clamp(0, 1)
                  : 0,
              minHeight: 2,
              backgroundColor: AppColors.surface,
              color: AppColors.pink,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openSearch(BuildContext context) async {
  final song = await showSearch<Song?>(
    context: context,
    delegate: TrackSearch(),
  );
  if (song != null && context.mounted) await openSong(context, song);
}

class TrackSearch extends SearchDelegate<Song?> {
  @override
  String get searchFieldLabel => 'Search songs or artists';
  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      tooltip: 'Clear search',
      onPressed: () {
        query = '';
      },
      icon: const Icon(Icons.close),
    ),
  ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
    tooltip: 'Back',
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );
  @override
  Widget buildResults(BuildContext context) => _results(context);
  @override
  Widget buildSuggestions(BuildContext context) => _results(context);
  Widget _results(BuildContext context) {
    final results = {for (final song in allSongs) song.id: song}.values
        .where(
          (s) => '${s.title} ${s.artist}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    if (results.isEmpty) {
      return const Center(child: Text('No songs found. Try another search.'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) => ListTile(
        leading: Artwork(results[i].image, width: 48, height: 48),
        title: Text(results[i].title),
        subtitle: Text(results[i].artist),
        onTap: () => close(context, results[i]),
      ),
    );
  }
}

Widget searchAction(BuildContext context) => IconButton(
  tooltip: 'Search',
  onPressed: () => openSearch(context),
  icon: const Icon(Icons.search, size: 25),
);

class EmptyMessage extends StatelessWidget {
  const EmptyMessage(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 50),
    child: Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.muted, height: 1.6),
      ),
    ),
  );
}
