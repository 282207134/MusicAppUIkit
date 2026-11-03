import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/music_store.dart';
import '../data/catalog.dart';
import '../widgets/music_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) => AppPage(
    id: 'home',
    navIndex: 0,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 110),
      children: [
        const Greeting(),
        const SizedBox(height: 30),
        CatalogSearch(onChanged: (value) => setState(() => query = value)),
        const SizedBox(height: 32),
        if (query.isEmpty) ...[
          AspectRatio(
            aspectRatio: 350 / 190,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Artwork('premium', radius: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 185,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '40%\nOFF',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Get Unlimited Download',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          GradientButton(
                            label: 'PREMIUM NOW',
                            width: 124,
                            height: 30,
                            fontSize: 12,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/cards'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SectionTitle(
            'Most Popular',
            onViewAll: () => Navigator.pushNamed(context, '/music_list'),
          ),
          const SongGrid(songs: popularSongs),
        ] else ...[
          const SectionTitle('Search Results'),
          if (allSongs.where(_matches).isEmpty)
            const EmptyMessage(
              'No songs found.\nTry a song title or an artist.',
            ),
          ...{
            for (final song in allSongs.where(_matches)) song.id: song,
          }.values.map((song) => SongTile(song)),
        ],
      ],
    ),
  );
  bool _matches(Song song) => '${song.title} ${song.artist}'
      .toLowerCase()
      .contains(query.toLowerCase());
}

class SongGrid extends StatelessWidget {
  const SongGrid({super.key, required this.songs, this.downloads = true});
  final List<Song> songs;
  final bool downloads;
  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: songs.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: downloads ? .72 : .73,
    ),
    itemBuilder: (_, i) => InkWell(
      onTap: () => openSong(context, songs[i], queue: songs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Artwork(songs[i].image),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            songs[i].title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          if (downloads)
            Row(
              children: [
                const Icon(
                  Icons.arrow_downward,
                  color: AppColors.pink,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    i == 1 ? '3.2 M Download' : '3.5 M Download',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            )
          else
            Text(
              songs[i].artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    ),
  );
}

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});
  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final songs = recentSongs
        .where(
          (s) => '${s.title} ${s.artist}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return AppPage(
      id: 'upcoming',
      navIndex: 1,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 110),
        children: [
          const Greeting(),
          const SizedBox(height: 30),
          CatalogSearch(onChanged: (value) => setState(() => query = value)),
          const SizedBox(height: 32),
          const SectionTitle('Upcoming'),
          SizedBox(
            height: 204,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: 2,
              separatorBuilder: (_, _) => const SizedBox(width: 20),
              itemBuilder: (_, i) {
                final song = i == 0
                    ? const Song(
                        'feel',
                        'Feel Your Arms',
                        'Justin Bieber',
                        'feel_your_arms',
                      )
                    : const Song(
                        'live',
                        'How Do I Live',
                        'Leann Rimes',
                        'how_do_i_live',
                      );
                return SizedBox(
                  width: 278,
                  child: InkWell(
                    onTap: () => openSong(context, song),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Artwork(song.image, width: 278, height: 145),
                        const SizedBox(height: 8),
                        Text(song.title, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          song.artist,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 26),
          const SectionTitle('Recently Played'),
          if (songs.isEmpty)
            const EmptyMessage('No recent songs match your search.'),
          ...songs.map((song) => SongTile(song, queue: recentSongs)),
        ],
      ),
    );
  }
}

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key, this.expanded = false});
  final bool expanded;
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late int tab = widget.expanded ? 1 : 0;
  String? filter;
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final argument = ModalRoute.of(context)?.settings.arguments;
      if (argument == 'Favorites' || argument == 'Downloads') {
        filter = argument as String;
      }
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    final base = widget.expanded || tab == 1 ? playlistSongs : mostPlayed;
    final songs = switch (filter) {
      'Favorites' =>
        allSongs.where((s) => store.favorites.contains(s.id)).toList(),
      'Downloads' =>
        allSongs.where((s) => store.downloads.contains(s.id)).toList(),
      _ => base,
    };
    return AppPage(
      id: widget.expanded ? 'music_list' : 'music',
      title: 'Music',
      action: searchAction(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 4, 32, 30),
            child: Row(
              children: List.generate(
                4,
                (i) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: tab == i
                        ? GradientButton(
                            label: ['Song', 'Playlist', 'Artist', 'Albums'][i],
                            height: 36,
                            fontSize: 14,
                            onPressed: () {},
                          )
                        : InkWell(
                            key: ValueKey('music_tab_$i'),
                            onTap: () => setState(() {
                              tab = i;
                              filter = null;
                            }),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                ['Song', 'Playlist', 'Artist', 'Albums'][i],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              children: [
                if (tab < 2) ...[
                  SectionTitle(
                    filter ?? 'Most Played',
                    onViewAll: () {
                      if (!widget.expanded) {
                        Navigator.pushNamed(context, '/music_list');
                      } else {
                        _filters(context);
                      }
                    },
                  ),
                  if (widget.expanded)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          for (final name in ['All', 'Favorites', 'Downloads'])
                            ChoiceChip(
                              label: Text(name),
                              selected: (filter ?? 'All') == name,
                              labelStyle: const TextStyle(fontSize: 12),
                              onSelected: (_) => setState(
                                () => filter = name == 'All' ? null : name,
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (songs.isEmpty)
                    EmptyMessage(
                      filter == 'Downloads'
                          ? 'Save a preview from a track menu\nto see it here.'
                          : 'Tap the heart on a song\nto add it to your favorites.',
                    ),
                  ...{for (final song in songs) song.id: song}.values.map(
                    (song) => SongTile(song, showPrice: true, queue: songs),
                  ),
                  if (!widget.expanded && filter == null) ...[
                    const SizedBox(height: 24),
                    SectionTitle(
                      'Popular Artists',
                      onViewAll: () =>
                          Navigator.pushNamed(context, '/following'),
                    ),
                    SongGrid(
                      downloads: false,
                      songs: const [
                        Song(
                          'singer',
                          'Shape of You',
                          'Ed Sheeran',
                          'popular_singer',
                        ),
                        Song(
                          'guitar',
                          'We Found Love',
                          'Michel Jackson',
                          'popular_guitar',
                        ),
                      ],
                    ),
                  ],
                ] else if (tab == 2) ...[
                  SectionTitle(
                    'Popular Artists',
                    onViewAll: () => Navigator.pushNamed(context, '/following'),
                  ),
                  ...artists.map((a) => ArtistTile(a)),
                ] else ...[
                  const SectionTitle('Albums'),
                  const SongGrid(songs: popularSongs, downloads: false),
                  const SizedBox(height: 20),
                  GradientButton(
                    label: 'Explore Categories',
                    onPressed: () =>
                        Navigator.pushNamed(context, '/categories'),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
          if (!widget.expanded) const MiniPlayer(),
        ],
      ),
    );
  }

  void _filters(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final value in ['All', 'Favorites', 'Downloads'])
            ListTile(
              title: Text(value),
              onTap: () {
                setState(() => filter = value == 'All' ? null : value);
                Navigator.pop(sheetContext);
              },
            ),
        ],
      ),
    ),
  );
}

class ArtistTile extends StatelessWidget {
  const ArtistTile(this.artist, {super.key});
  final Artist artist;
  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    final following = store.followed.contains(artist.name);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () =>
                Navigator.pushNamed(context, '/artist', arguments: artist.name),
            child: Artwork(artist.image, width: 70, height: 70),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                '/artist',
                arguments: artist.name,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artist.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GradientButton(
            key: ValueKey('follow_${artist.image}'),
            label: following ? 'Unfollow' : 'Follow',
            width: 73,
            height: 32,
            fontSize: 12,
            onPressed: () => store.toggleFollow(artist.name),
          ),
        ],
      ),
    );
  }
}

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key, this.artist});
  final String? artist;
  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    final name = artist ?? 'Justin Bieber';
    final matchingSongs = {
      for (final song in allSongs.where((song) => song.artist.contains(name)))
        song.id: song,
    }.values.toList();
    final songs = artist == null || matchingSongs.isEmpty
        ? artistSongs
        : matchingSongs;
    final artwork = artist == null
        ? 'artist_hero'
        : artists.where((a) => a.name == name).firstOrNull?.image ??
              'artist_hero';
    return AppPage(
      id: 'artist',
      title: 'Artist',
      navIndex: 2,
      action: searchAction(context),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 4, 32, 110),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).width < 360 ? 238 : 196,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artist == null ? 'Your Love' : name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Best Music For You and\nyour homies',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        key: const ValueKey('artist_follow'),
                        label: store.followed.contains(name)
                            ? 'Following'
                            : 'Follow',
                        width: 132,
                        height: 40,
                        onPressed: () => store.toggleFollow(name),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Artwork(
                  artwork,
                  width: (MediaQuery.sizeOf(context).width * .36).clamp(
                    100.0,
                    150.0,
                  ),
                  height: 167,
                  radius: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          ...songs.map((song) {
            final active = store.currentSong.id == song.id;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 8,
              title: Text(
                song.title,
                style: TextStyle(
                  fontSize: 16,
                  color: active ? AppColors.pink : Colors.white,
                ),
              ),
              subtitle: Text(
                song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: active ? AppColors.pink : AppColors.muted,
                ),
              ),
              trailing: Icon(
                active && store.playing
                    ? Icons.graphic_eq
                    : Icons.chevron_right,
                size: 22,
                color: active ? AppColors.pink : AppColors.muted,
              ),
              onTap: () => openSong(context, song, queue: songs),
            );
          }),
        ],
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    id: 'categories',
    title: 'Category',
    action: searchAction(context),
    child: GridView.builder(
      padding: const EdgeInsets.fromLTRB(32, 4, 32, 24),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 20,
        childAspectRatio: 166 / 170,
      ),
      itemBuilder: (_, i) => Semantics(
        button: true,
        label: categories[i].$1,
        child: InkWell(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            builder: (sheetContext) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SectionTitle(categories[i].$1),
                    for (final song in [
                      playlistSongs[i % playlistSongs.length],
                      recentSongs[i % recentSongs.length],
                    ])
                      ListTile(
                        leading: Artwork(song.image, width: 48, height: 48),
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          openSong(context, song);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Artwork(categories[i].$2),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    categories[i].$1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
