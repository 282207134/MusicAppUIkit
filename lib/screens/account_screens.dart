import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/music_store.dart';
import '../data/catalog.dart';
import '../widgets/music_widgets.dart';
import 'browse_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    return AppPage(
      id: 'profile',
      title: 'Profile',
      navIndex: 3,
      action: IconButton(
        key: const ValueKey('open_settings'),
        tooltip: 'Settings',
        onPressed: () => Navigator.pushNamed(context, '/settings'),
        icon: const Icon(Icons.edit_square, size: 23),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 4, 32, 110),
        children: [
          const Center(
            child: Artwork('jessica', width: 154, height: 154, radius: 0),
          ),
          const SizedBox(height: 16),
          Text(
            store.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 9),
          const Text(
            'Premium User',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const SizedBox(height: 42),
          Row(
            children: [
              _stat(
                context,
                '${store.followed.length}',
                'Followed Singer',
                '/following',
              ),
              _stat(
                context,
                '${store.favorites.length}',
                'Favorites',
                '/music_list',
                arguments: 'Favorites',
              ),
              _stat(context, '24', 'Followed Albums', '/upcoming'),
            ],
          ),
          const SizedBox(height: 42),
          SectionTitle(
            'Followed Artist',
            onViewAll: () => Navigator.pushNamed(context, '/following'),
          ),
          ...artists.take(4).map((a) => ArtistTile(a)),
        ],
      ),
    );
  }

  Widget _stat(
    BuildContext context,
    String number,
    String label,
    String route, {
    String? arguments,
  }) => Expanded(
    child: InkWell(
      onTap: () => Navigator.pushNamed(context, route, arguments: arguments),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: AppColors.pink,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    ),
  );
}

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    id: 'following',
    title: 'Following',
    action: searchAction(context),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(32, 4, 32, 24),
      children: [
        const SectionTitle('Followed Artist'),
        ...artists.map((a) => ArtistTile(a)),
      ],
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    final rows = <(IconData, String, VoidCallback)>[
      (Icons.person_outline, 'Accounts', () => _editAccount(context)),
      (
        Icons.payments_outlined,
        'Cards',
        () => Navigator.pushNamed(context, '/cards'),
      ),
      (
        Icons.notifications_none,
        'Notification',
        () => showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Notifications'),
            content: const Text(
              'Enable in-app music announcements? This demo does not send push notifications.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  store.setNotifications(false);
                  Navigator.pop(dialogContext);
                },
                child: const Text('Turn off'),
              ),
              TextButton(
                onPressed: () {
                  store.setNotifications(true);
                  Navigator.pop(dialogContext);
                },
                child: const Text('Enable'),
              ),
            ],
          ),
        ),
      ),
      (
        Icons.receipt_long_outlined,
        'Purchase History',
        () => _info(
          context,
          'Purchase History',
          'No purchases yet. Demo checkout never charges your card.',
        ),
      ),
      (
        Icons.history,
        'Activity History',
        () => _info(
          context,
          'Activity History',
          'Current track: ${store.currentSong.title}\n\n${store.favorites.length} favorites · ${store.downloads.length} saved previews',
        ),
      ),
      (
        Icons.lock_outline,
        'Change Password',
        () => Navigator.pushNamed(context, '/reset_password'),
      ),
      (
        Icons.language,
        'Change Language',
        () => Navigator.pushNamed(context, '/language', arguments: 'settings'),
      ),
      (
        Icons.system_update_outlined,
        'Update',
        () => _info(
          context,
          'You’re up to date',
          'Music UI Kit\nVersion 1.0.0\n\nYou have the latest version of this local demo.',
        ),
      ),
      (Icons.help_outline, 'Help Center', () => _help(context)),
      (Icons.chat_bubble_outline, 'Feedback', () => _feedback(context)),
      (
        Icons.privacy_tip_outlined,
        'Privacy Policy',
        () => Navigator.pushNamed(context, '/privacy'),
      ),
    ];
    return AppPage(
      id: 'settings',
      title: 'Settings',
      action: searchAction(context),
      footer: InkWell(
        key: const ValueKey('logout'),
        onTap: () => showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Log out?'),
            content: const Text(
              'Your favorites and preferences will stay on this device.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                key: const ValueKey('confirm_logout'),
                onPressed: () async {
                  await store.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (_) => false,
                    );
                  }
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
        child: const SizedBox(
          height: 42,
          child: Row(
            children: [
              Icon(Icons.logout, size: 22, color: AppColors.pink),
              SizedBox(width: 18),
              Text('Log Out', style: TextStyle(color: AppColors.pink)),
              Spacer(),
              Icon(Icons.chevron_right, color: AppColors.pink),
            ],
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 4, 32, 20),
        children: rows
            .map(
              (r) => ListTile(
                key: ValueKey('setting_${r.$2}'),
                contentPadding: EdgeInsets.zero,
                minTileHeight: 48,
                horizontalTitleGap: 18,
                leading: Icon(r.$1, size: 23),
                title: Text(r.$2, style: const TextStyle(fontSize: 18)),
                trailing: r.$2 == 'Notification'
                    ? Icon(
                        store.notifications
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                        size: 21,
                        color: AppColors.muted,
                      )
                    : const Icon(
                        Icons.chevron_right,
                        size: 23,
                        color: AppColors.muted,
                      ),
                onTap: r.$3,
              ),
            )
            .toList(),
      ),
    );
  }

  void _info(BuildContext context, String title, String message) =>
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Done'),
            ),
          ],
        ),
      );
  Future<void> _editAccount(BuildContext context) async {
    final store = MusicScope.of(context),
        controller = TextEditingController(text: MusicScope.of(context).name);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              maxLength: 40,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: 12),
            Text(
              store.email,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(dialogContext, controller.text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) store.updateName(result);
    // Wait for the dialog's closing animation before releasing its controller.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
  }

  void _help(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SectionTitle('Help Center'),
            ExpansionTile(
              title: Text('How does playback work?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Tap any track to play an original 30-second preview. The bundled preview works offline. Artist names and artwork come from the UI reference.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Where are my favorites?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Tap the heart in Now Playing, then open My Music → View All → Favorites.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Can I make a payment?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Cards and checkout are sample screens. No real payment or online account is connected.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  Future<void> _feedback(BuildContext context) async {
    final controller = TextEditingController();
    final feedback = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Feedback'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 500,
          decoration: const InputDecoration(
            hintText: 'Tell us what you think about this demo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(dialogContext, controller.text.trim());
              }
            },
            child: const Text('Save locally'),
          ),
        ],
      ),
    );
    if (feedback != null && context.mounted) {
      await MusicScope.of(context).saveFeedback(feedback);
      if (context.mounted) notice(context, 'Feedback saved on this device.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
  }
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String query = '';
  String? selected;
  @override
  Widget build(BuildContext context) {
    final store = MusicScope.of(context);
    final current = selected ?? store.language;
    final choices = languages.where(
      (l) => l.$1.toLowerCase().contains(query.toLowerCase()),
    );
    return AppPage(
      id: 'language',
      title: 'Language',
      footer: GradientButton(
        key: const ValueKey('language_continue'),
        label: 'Continue',
        onPressed: () {
          store.setLanguage(current);
          if (ModalRoute.of(context)?.settings.arguments == 'settings') {
            Navigator.pop(context);
          } else {
            goHome(context);
          }
        },
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 62, 32, 24),
        children: [
          const Text(
            'Choose Language',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          const Text(
            'Services are available in all languages.\nYou can change the display language to your preferred language at any time.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 50),
          TextField(
            key: const ValueKey('language_search'),
            onChanged: (v) => setState(() => query = v),
            decoration: const InputDecoration(
              hintText: 'Search your own language',
              prefixIcon: Icon(Icons.search, color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 24),
          if (choices.isEmpty) const EmptyMessage('No matching language.'),
          ...choices.map(
            (l) => InkWell(
              key: ValueKey('language_${l.$2}'),
              onTap: () => setState(() => selected = l.$1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Artwork('flag_${l.$2}', width: 48, height: 32, radius: 20),
                    const SizedBox(width: 20),
                    Expanded(child: Text(l.$1)),
                    Icon(
                      current == l.$1 ? Icons.check_circle : Icons.circle,
                      size: 20,
                      color: current == l.$1
                          ? AppColors.pink
                          : AppColors.surface,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Preference is saved locally. Demo content is in English.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});
  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  int selected = 1;
  static const cards = [
    ('VISA', 'Visa Master', '7863'),
    ('●●', 'Master Card', '3197'),
    ('AMEX', 'American Express', '9716'),
  ];
  @override
  Widget build(BuildContext context) => AppPage(
    id: 'cards',
    title: 'Card',
    action: searchAction(context),
    footer: GradientButton(
      key: const ValueKey('pay_now'),
      label: 'Pay Now',
      onPressed: () => showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Demo checkout'),
          content: Text(
            'Premium plan · \$4.99 / month\n${cards[selected].$2} ending ${cards[selected].$3}\n\nThis is a sample payment flow. No real charge will be made.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              key: const ValueKey('confirm_demo_payment'),
              onPressed: () {
                Navigator.pop(dialogContext);
                notice(
                  context,
                  'Demo checkout complete. No payment was processed.',
                );
              },
              child: const Text('Complete demo'),
            ),
          ],
        ),
      ),
    ),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(32, 4, 32, 24),
      children: [
        for (var i = 0; i < cards.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Semantics(
              selected: i == selected,
              button: true,
              child: InkWell(
                key: ValueKey('card_$i'),
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => selected = i),
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: selected == i ? AppColors.gradient : null,
                  ),
                  child: Container(
                    height: 94,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected == i
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selected == i
                              ? AppColors.pink
                              : AppColors.muted,
                          size: 22,
                        ),
                        const SizedBox(width: 18),
                        SizedBox(
                          width: 54,
                          child: Text(
                            cards[i].$1,
                            style: TextStyle(
                              fontSize: i == 1 ? 28 : 16,
                              fontStyle: i == 0
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              color: i == 1 ? AppColors.coral : Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cards[i].$2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'xxxx - xxxx - xxxx - ${cards[i].$3}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.muted,
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
          ),
        const Text(
          'Sample cards · demonstration only',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: AppColors.muted),
        ),
      ],
    ),
  );
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    id: 'privacy',
    title: 'Privacy Policy',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
      children: const [
        Text(
          'Music & Arts Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 24),
        Text(
          'This Flutter application is a local demonstration of the Music UI Kit. It does not connect to an online account, payment processor, analytics provider, or music catalog service.',
          style: TextStyle(fontSize: 16, color: AppColors.muted, height: 1.5),
        ),
        SizedBox(height: 24),
        Text('Your information', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 16),
        Text(
          'Your display name, sample email, favorites, followed artists, saved previews, language preference, notification preference and locally saved feedback are stored on this device. Passwords, verification codes and full card numbers are never stored.\n\nUse your device’s app settings to clear application storage and remove this information.',
          style: TextStyle(fontSize: 16, color: AppColors.muted, height: 1.5),
        ),
        SizedBox(height: 24),
        Text('More About', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 16),
        Text(
          'Artwork and artist names are included to reproduce the supplied design reference. Every track uses the same original, bundled 30-second preview rather than a commercial recording.\n\nSocial sign-in, verification and checkout screens simulate their respective workflows. No email is sent and no payment is processed. Choosing a language saves a preference; the demonstration interface remains in English.',
          style: TextStyle(fontSize: 16, color: AppColors.muted, height: 1.5),
        ),
      ],
    ),
  );
}
