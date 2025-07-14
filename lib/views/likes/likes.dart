import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  Widget sectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 0, 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget notificationItem({
    required BuildContext context,
    required String avatarUrl,
    required String username,
    required String message,
    String? time,
    String? imageUrl,
    Widget? actionButton,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messageColor = isDark ? Colors.grey[800] : Colors.grey[300];
    final textColor = isDark ? Colors.white : Colors.black;

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: textColor),
          children: [
            TextSpan(
              text: "$username ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: message),
            if (time != null)
              TextSpan(
                text: " · $time",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
      trailing: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl,
                  width: 50, height: 50, fit: BoxFit.cover),
            )
          : actionButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Following',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'You',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
            child: Text(
              'Follow Requests',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
          ),
          sectionTitle('New', context),
          notificationItem(
            context: context,
            avatarUrl: 'https://randomuser.me/api/portraits/women/10.jpg',
            username: 'karennne',
            message: 'liked your photo.',
            time: '1h',
            imageUrl:
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
          ),
          sectionTitle('Today', context),
          notificationItem(
            context: context,
            avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
            username: 'kiero_d, zackjohn and 26 others',
            message: 'liked your photo.',
            time: '3h',
            imageUrl:
                'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
          ),
          sectionTitle('This Week', context),
          notificationItem(
            context: context,
            avatarUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
            username: 'craig_love',
            message: 'mentioned you in a comment: @jacob_w exactly..',
            time: '2d',
            imageUrl:
                'https://images.unsplash.com/photo-1470770841072-f978cf4d019e',
          ),
          notificationItem(
            context: context,
            avatarUrl: 'https://randomuser.me/api/portraits/men/15.jpg',
            username: 'martini_rond',
            message: 'started following you.',
            time: '3d',
            actionButton: TextButton(
              onPressed: () {},
              child: Text(
                'Message',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          notificationItem(
            context: context,
            avatarUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
            username: 'maxjacobson',
            message: 'started following you.',
            time: '3d',
            actionButton: TextButton(
              onPressed: () {},
              child: Text(
                'Message',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          notificationItem(
            context: context,
            avatarUrl: 'https://randomuser.me/api/portraits/women/20.jpg',
            username: 'mis_potter',
            message: 'started following you.',
            time: '3d',
            actionButton: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
              ),
              child: const Text('Follow'),
            ),
          ),
        ],
      ),
    );
  }
}
