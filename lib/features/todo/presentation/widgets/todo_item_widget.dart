// PRESENTATION - todo_item_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_clean_architecture/features/todo/domain/entities/todo_entity.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoEntity todo;

  const TodoItemWidget({super.key, required this.todo});

  String get _todoUrl =>
      'https://jsonplaceholder.typicode.com/todos/${todo.id}';

  String get _avatarUrl =>
      'https://api.dicebear.com/9.x/bottts/png?seed=${todo.id}&size=64';

  Future<void> _openUrl() async {
    final uri = Uri.parse(_todoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _share() async {
    final status = todo.completed ? '✅ Done' : '⏳ Pending';
    await SharePlus.instance.share(
      ShareParams(
        text: '$status — ${todo.title}\n$_todoUrl',
        subject: todo.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: _avatarUrl,
        imageBuilder: (ctx, img) => CircleAvatar(backgroundImage: img),
        placeholder: (ctx, _) => const CircleAvatar(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (ctx, _, _) => CircleAvatar(
          backgroundColor: todo.completed
              ? Colors.green.shade100
              : Colors.orange.shade100,
          child: Icon(
            todo.completed ? Icons.check : Icons.pending,
            color: todo.completed ? Colors.green : Colors.orange,
            size: 20,
          ),
        ),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed ? Colors.grey : null,
        ),
      ),
      subtitle: todo.description != null
          ? Text(
              todo.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(
              todo.completed ? 'Done' : 'Pending',
              style: const TextStyle(fontSize: 11),
            ),
            backgroundColor: todo.completed
                ? Colors.green.shade50
                : Colors.orange.shade50,
            side: BorderSide.none,
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: const Icon(Icons.share, size: 18),
            tooltip: 'Share',
            onPressed: _share,
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new, size: 18),
            tooltip: 'View on web',
            onPressed: _openUrl,
          ),
        ],
      ),
    );
  }
}
