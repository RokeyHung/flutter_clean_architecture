// PRESENTATION - add_todo_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';
import '../providers/todo_providers.dart';
import '../state/todo_state.dart';

@RoutePage()
class AddTodoPage extends ConsumerStatefulWidget {
  const AddTodoPage({super.key});

  @override
  ConsumerState<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends ConsumerState<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isLoading = false;
  OgpData? _ogpData;
  bool _fetchingOgp = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _fetchOgp(String url) async {
    if (url.isEmpty) {
      setState(() => _ogpData = null);
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return;

    setState(() => _fetchingOgp = true);
    try {
      final data = await OgpDataExtract.execute(url);
      if (mounted) setState(() => _ogpData = data);
    } catch (_) {
      if (mounted) setState(() => _ogpData = null);
    } finally {
      if (mounted) setState(() => _fetchingOgp = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final description = [
      if (_descController.text.trim().isNotEmpty) _descController.text.trim(),
      if (_urlController.text.trim().isNotEmpty) _urlController.text.trim(),
    ].join('\n').trim();

    await ref
        .read(todoNotifierProvider.notifier)
        .addTodo(
          _titleController.text.trim(),
          description: description.isEmpty ? null : description,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final currentState = ref.read(todoNotifierProvider);
    if (currentState is TodoError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(currentState.message),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo added!'),
          backgroundColor: Colors.green,
        ),
      );
      context.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title — ExtendedTextField (supports special text spans, emoji, etc.)
              ExtendedTextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                maxLines: 1,
                textInputAction: TextInputAction.next,
                specialTextSpanBuilder:
                    null, // extend nếu cần @mention, #hashtag
              ),
              const SizedBox(height: 4),
              // Inline validator
              ValueListenableBuilder(
                valueListenable: _titleController,
                builder: (_, value, _) {
                  final text = value.text.trim();
                  if (text.isEmpty) {
                    return const Text(
                      'Title is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    );
                  }
                  if (text.length < 3) {
                    return const Text(
                      'At least 3 characters',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              // URL — OGP preview
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'URL (optional)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.link),
                  suffixIcon: _fetchingOgp
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onChanged: (v) => _fetchOgp(v.trim()),
              ),
              // OGP preview card
              if (_ogpData != null) ...[
                const SizedBox(height: 12),
                _OgpPreviewCard(data: _ogpData!),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading || _titleController.text.trim().length < 3
                    ? null
                    : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Todo', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── OGP Preview Card ──────────────────────────────────────────────────────────

class _OgpPreviewCard extends StatelessWidget {
  final OgpData data;
  const _OgpPreviewCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.image != null)
            Image.network(
              data.image!,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.title != null)
                  Text(
                    data.title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (data.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.description!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (data.url != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.url!,
                    style: const TextStyle(fontSize: 11, color: Colors.blue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
