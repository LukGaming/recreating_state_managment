import 'dart:async';

import 'package:flutter/material.dart';
import 'package:utilizando_gerenciamendo_estado/presentation/controllers/posts_controller.dart';
import 'package:utilizando_gerenciamendo_estado/presentation/state/posts_state.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final postsController = PostsController();

  @override
  void initState() {
    postsController.getPosts();

    postsController.addListener(_callback);

    super.initState();
  }

  void _callback() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuildando primeiro widget");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VerifyindState(postsState: postsController.state),
            const CounterWidget()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        postsController.generateError();
      }),
    );
  }

  @override
  void dispose() {
    postsController.removeListener(_callback);
    super.dispose();
  }
}

class VerifyindState extends StatelessWidget {
  final PostsState postsState;

  const VerifyindState({
    super.key,
    required this.postsState,
  });

  @override
  Widget build(BuildContext context) {
    if (postsState is LoadingState) {
      return const CircularProgressIndicator();
    }
    if (postsState is PostsLoaded) {
      final state = (postsState as PostsLoaded);
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Text("corpo do post: ${state.posts[index].body}");
          },
          itemCount: state.posts.length,
        ),
      );
    }
    if (postsState is ErrorState) {
      return Column(
        children: [
          const Icon(
            Icons.dangerous,
            color: Colors.red,
            size: 80,
          ),
          Text("Ocorreu um erro: ${(postsState as ErrorState).message}")
        ],
      );
    }
    return Text("O estado é: $postsState");
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final counterController = CounterBloc();

  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    _subscription = counterController.streamController.stream.listen(_callback);
    super.initState();
  }

  void _callback(int newState) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("CounterValue: ${counterController.state}"),
        ElevatedButton(
          onPressed: () {
            counterController.update(10);
          },
          child: const Text("Increment"),
        ),
        ElevatedButton(
          onPressed: () {
            counterController.dispose();
          },
          child: const Text("DisposeBloc"),
        )
      ],
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
