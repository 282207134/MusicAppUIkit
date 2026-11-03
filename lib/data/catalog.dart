class Song {
  const Song(
    this.id,
    this.title,
    this.artist,
    this.image, {
    this.price = '1.49',
  });
  final String id, title, artist, image, price;
}

class Artist {
  const Artist(this.name, this.location, this.image);
  final String name, location, image;
}

const featuredSong = Song(
  'let_me_love_you',
  'Let Me Love You',
  'John Lennon',
  'player',
);
const popularSongs = [
  Song('shape', 'Shape of You', 'Ed Sheeran', 'shape_of_you'),
  Song(
    'found',
    'We Found Love',
    'Rihanna Feat. Calvin Harris',
    'popular_found_love',
  ),
  Song('stage', 'Shape of You', 'Ed Sheeran', 'popular_stage'),
  Song('dj', 'We Found Love', 'Calvin Harris', 'popular_dj'),
];
const mostPlayed = [
  Song('love', 'Love', 'Calvin Harris', 'love', price: '1.69'),
  Song('perfect', 'Perfect', 'Carly Simon', 'perfect', price: '2.85'),
  Song('rockstar', 'Rockstar', 'Calvin Harris', 'rockstar', price: '1.40'),
];
const playlistSongs = [
  Song('hold_on', 'Hold On', 'Justin Bieber', 'justin'),
  Song('again', 'See You Again', 'Wiz Khalifa', 'see_you_again', price: '2.65'),
  Song('blank', 'Blank Space', 'Taylor Swift', 'blank_space', price: '1.50'),
  Song('let_her', 'Let Her Go', 'Passenger', 'let_her_go', price: '1.60'),
  Song('closer', 'Closer', 'The Chainsmokers', 'closer', price: '1.20'),
  Song(
    'thinking',
    'Thinking Out Loud',
    'Ed Sheeran',
    'thinking_out_loud',
    price: '1.10',
  ),
  Song('rockstar', 'Rockstar', 'Calvin Harris', 'rockstar', price: '1.40'),
];
const recentSongs = [
  Song(
    'recent_love',
    'We Found Love',
    'Rihanna Feat. Calvin Harris',
    'we_found_love',
  ),
  Song('orleans', 'The Battle of New Orleans', 'Johnny Horton', 'new_orleans'),
  Song(
    'sweet_day',
    'One Sweet Day',
    'Mariah Carey & Boyz II Men',
    'one_sweet_day',
  ),
  Song('call', 'Call Me Maybe', 'Carly Rae Jepsen', 'call_me_maybe'),
];
const artistSongs = [
  Song('despacito', 'Despacito', 'Luis Fonsi, Daddy & Justin Bieber', 'justin'),
  Song('dont_care', "I Don't Care", 'Ed Sheeran & Justin Bieber', 'justin'),
  Song('intentions', 'Intentions', 'Justin Bieber Featuring Quavo', 'justin'),
  Song('holy', 'Holy', 'Justin Bieber Featuring Chance The Rapper', 'justin'),
  Song('stuck', 'Stuck With U', 'Ariana Grande & Justin Bieber', 'justin'),
  Song('loved', 'Loved By You', 'Justin Bieber Featuring Burna Boy', 'justin'),
  Song('die', 'Die For You', 'Justin Bieber Featuring Dominic Fike', 'justin'),
  Song('as_i_am', 'As I Am', 'Justin Bieber Featuring Khalid', 'justin'),
];
const artists = [
  Artist('The Weeknd', 'Toronto, Canada', 'weeknd'),
  Artist('Justin Bieber', 'London, Canada', 'justin'),
  Artist('Ariana Grande', 'Florida, United States', 'ariana'),
  Artist('Ed Sheeran', 'Halifax, United Kingdom', 'ed_following'),
  Artist('Dua Lipa', 'London, United Kingdom', 'dua'),
  Artist('John Legend', 'Ohio, United States', 'john'),
  Artist('James Blake', 'London, United Kingdom', 'james'),
  Artist('Anne Marie', 'Tilbury, United Kingdom', 'anne'),
];
const categories = <(String, String)>[
  ('Hip Hop', 'hip_hop'),
  ('Romantic', 'romantic'),
  ('Rock Music', 'rock'),
  ('Soul Music', 'soul'),
  ('Folk Punk', 'folk'),
  ('Acoustic Blues', 'acoustic'),
  ('Blues Music', 'blues'),
  ('Classical Songs', 'classical'),
];
const languages = <(String, String)>[
  ('American English', 'us'),
  ('Bangladesh', 'bd'),
  ('China', 'cn'),
  ('Germany', 'de'),
  ('Russia', 'ru'),
];
const allSongs = [
  featuredSong,
  ...popularSongs,
  ...mostPlayed,
  ...playlistSongs,
  ...recentSongs,
  ...artistSongs,
];
