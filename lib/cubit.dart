import 'package:flutter_bloc/flutter_bloc.dart';

import 'main.dart';

class MovieCubit extends Cubit<List<Movie>> {
  MovieCubit() : super([]);

  void aumentar(Movie movie) {
    movie.cantidadEntradas++;
    state.add(movie);
    emit(List.from(state));
  }

  void restar(Movie movie) {
    movie.cantidadEntradas--;
    state.add(movie);
    emit(List.from(state));
  }

  void confirmarCompra(Movie movie) {
    movie.confirmaCompra = true;
    state.add(movie);
    emit(List.from(state));
  }
}
