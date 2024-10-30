import 'package:utilizando_gerenciamendo_estado/post.dart';

abstract class PostsState {}

class InitialState extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;

  PostsLoaded(this.posts);
}

class LoadingState extends PostsState {}

class ErrorState extends PostsState {
  final String message;

  ErrorState(this.message);
}
