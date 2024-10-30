import 'package:utilizando_gerenciamendo_estado/post.dart';

class PostsRepository {
  Future<List<Post>> get() async {
    return [
      const Post(id: 1, body: "Primeiro post"),
      const Post(id: 2, body: "Segundo post"),
    ];
  }
}
