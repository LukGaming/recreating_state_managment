import 'dart:async';

import 'package:utilizando_gerenciamendo_estado/data/repositories/posts_repository.dart';
import 'package:utilizando_gerenciamendo_estado/presentation/state/posts_state.dart';

class PostsController extends StateValueNotifier<PostsState> {
  PostsRepository postsRepository = PostsRepository();

  var count = 0.obs();

  PostsController() : super(InitialState());

  Future<void> getPosts() async {
    count.state++;

    state = LoadingState();

    try {
      await Future.delayed(const Duration(seconds: 2));
      state = PostsLoaded(await postsRepository.get());
    } catch (e) {
      state = ErrorState("Não foi possível carregar os posts");
    }
  }

  void generateError() {
    state = ErrorState("Erro gerado manualmente");
  }
}

class CounterNotifier extends StateValueNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => emit(state++);
  void decrement() => emit(state--);

  void emit(int newState) {
    state = newState;
  }
}

// => await postsController.getPosts();

//InitialState -> IddleState

//Loading

//SuccessState

//ErrorState

// Padrão observer

//Você escute

//Você reage quando ouvir

abstract class Observer {
  void addListener(void Function() callback);

  void removeListener(void Function() callback);
}

class StateObserver implements Observer {
  final List<void Function()> _callbacks = [];

  @override
  void addListener(void Function() callback) {
    if (!_callbacks.contains(callback)) _callbacks.add(callback);
  }

  @override
  void removeListener(void Function() callback) {
    if (_callbacks.contains(callback)) _callbacks.remove(callback);
  }

  void executeCallbacks() {
    for (void Function() callback in _callbacks) {
      callback.call();
    }
  }
}

class StateValueNotifier<T> extends StateObserver implements StateNotifier {
  StateValueNotifier(this._state);

  T _state;

  @override
  T get state => _state;

  set state(T newState) {
    _state = newState;
    executeCallbacks();
  }
}

abstract class StateNotifier<T> {
  T get state;
}

extension ReactiveInt on int {
  StateValueNotifier obs() {
    return StateValueNotifier(this);
  }
}

abstract class TrackeableBloc<E extends Exception, State extends Object> {
  BlocError<E, State> onError(E exception, State s);
}

class Bloc<State extends Object> {
  State state;

  Bloc(this.state) {
    state = this.state;
    streamController.add(state);
    onCreation(state);
  }

  StreamController<State> streamController = StreamController<State>();

  void update(State newState) {
    try {
      state = newState;
      streamController.add(state);
      onUpdate(newState);
    } catch (e) {
      print("erro aqui em cima: $e");
      if (e is StateError) {
        onError(
            Exception("Atualizando valor do BLOC após o dispose..."), newState);
        return;
      }
      onError(e, newState);
    }
  }

  BlocError<dynamic, State> onError(dynamic exception, State s) {
    return BlocError(exception: exception, state: state);
  }

  State onCreation(State initialState) {
    return initialState;
  }

  State onUpdate(State newState) {
    return newState;
  }

  void dispose() {
    streamController.close();
    onDispose();
  }

  void onDispose() {}
}

class BlocError<E extends dynamic, S extends Object> {
  final E exception;
  final S state;

  BlocError({required this.exception, required this.state});
}

class CounterBloc extends Bloc<int> {
  CounterBloc() : super(0);

  void increment() {
    update(state++);
  }

  @override
  BlocError<dynamic, int> onError(dynamic exception, int s) {
    print("Gerando erro: $exception");
    return super.onError(exception, s);
  }

  @override
  int onCreation(int initialState) {
    print("Iniciando estado com: $initialState");
    return super.onCreation(initialState);
  }

  @override
  int onUpdate(int newState) {
    print("Estado atualizado para: $newState");
    return super.onUpdate(newState);
  }

  @override
  void onDispose() {
    print("Disposing...");
    super.onDispose();
  }
}
