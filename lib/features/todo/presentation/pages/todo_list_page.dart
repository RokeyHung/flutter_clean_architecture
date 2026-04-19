// PRESENTATION - todo_list_page.dart
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:auto_route/auto_route.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/app_info_service.dart';
import '../providers/todo_providers.dart';
import '../state/todo_state.dart';
import '../widgets/todo_item_widget.dart';

@RoutePage()
class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  final List<_TipBanner> _tips = const [
    _TipBanner(
      icon: Icons.checklist_rounded,
      title: 'Organize your day',
      subtitle: 'Add todos and keep track of your tasks',
      color: Color(0xFF6C63FF),
    ),
    _TipBanner(
      icon: Icons.offline_bolt_rounded,
      title: 'Works offline',
      subtitle: 'Your todos are cached locally with SharedPreferences',
      color: Color(0xFF43A047),
    ),
    _TipBanner(
      icon: Icons.security_rounded,
      title: 'Secure storage',
      subtitle: 'Sensitive data is stored with flutter_secure_storage',
      color: Color(0xFFE53935),
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(todoNotifierProvider.notifier).loadTodos());
  }

  // Cập nhật app icon badge với số todo pending
  void _updateAppBadge(List todos) {
    final pendingCount = todos.where((t) => !t.completed).length;
    AppBadgePlus.updateBadge(pendingCount);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(todoNotifierProvider.notifier).loadTodos(),
          ),
          _buildAppInfoButton(context),
        ],
      ),
      drawer: _buildDrawer(context),
      body: switch (state) {
        TodoInitial() => const Center(child: Text('Pull down to refresh')),
        TodoLoading() => const Center(child: CircularProgressIndicator()),
        TodoLoaded(:final todos) => RefreshIndicator(
          onRefresh: () => ref.read(todoNotifierProvider.notifier).loadTodos(),
          child: Builder(
            builder: (context) {
              _updateAppBadge(todos);
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildCarousel()),
                  if (todos.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('No todos yet. Add one!')),
                    )
                  else
                    SliverList.separated(
                      itemCount: todos.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          TodoItemWidget(todo: todos[index]),
                    ),
                ],
              );
            },
          ),
        ),
        TodoError(:final message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(todoNotifierProvider.notifier).loadTodos(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      },
      floatingActionButton: _buildFab(state),
    );
  }

  Widget _buildFab(TodoState state) {
    final pendingCount = switch (state) {
      TodoLoaded(:final todos) => todos.where((t) => !t.completed).length,
      _ => 0,
    };

    final fab = FloatingActionButton(
      onPressed: () => context.pushRoute(const AddTodoRoute()),
      child: const Icon(Icons.add),
    );

    if (pendingCount == 0) return fab;

    return badges.Badge(
      badgeContent: Text(
        '$pendingCount',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      child: fab,
    );
  }

  Widget _buildCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 90,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          viewportFraction: 0.88,
          enlargeCenterPage: true,
        ),
        items: _tips.map((tip) => _TipBannerCard(tip: tip)).toList(),
      ),
    );
  }

  Widget _buildAppInfoButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: AppInfoService.versionDisplay,
      onPressed: () => showAboutDialog(
        context: context,
        applicationName: AppInfoService.appName.isEmpty
            ? 'Flutter Clean Architecture'
            : AppInfoService.appName,
        applicationVersion: AppInfoService.versionDisplay,
        children: [const Text('Clean Architecture + Riverpod + Freezed + Dio')],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://avatars.githubusercontent.com/u/14101776?v=4',
                  imageBuilder: (ctx, img) =>
                      CircleAvatar(radius: 28, backgroundImage: img),
                  placeholder: (ctx, _) => const CircleAvatar(
                    radius: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (ctx, _, _) =>
                      const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Flutter Clean Architecture',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  AppInfoService.versionDisplay,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Todos'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// ── Internal widgets ──────────────────────────────────────────────────────────

class _TipBanner {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _TipBanner({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _TipBannerCard extends StatelessWidget {
  final _TipBanner tip;
  const _TipBannerCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: tip.color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(tip.icon, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tip.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  tip.subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
