import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_examen/pages/pagina_detalles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peliculas_examen/cubit.dart';

void main() {
  final cartCubit = MovieCubit();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cartCubit),
      ],
      child: MyApp(),
    ),
  );
}

class Movie {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  double precio;
  int cantidadEntradas;

  bool confirmaCompra;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.precio = 30,
    this.cantidadEntradas = 0,
    this.confirmaCompra = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(json['genre_ids']),
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'].toDouble(),
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      title: json['title'],
      video: json['video'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fa3e844ce31744388e07fa47c7c5d8c3'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> movieList = data['results'];

      final List<Movie> parsedMovies =
          movieList.map((json) => Movie.fromJson(json)).toList();
      movies = parsedMovies;
      setState(() {
        movies = parsedMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Películas en Cartelera'),
        ),
        body: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              title: Text(movie.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.overview),
                  Text(
                      'Precio de entrada: '+ movie.precio.toStringAsFixed(2)+'Bs'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (movie.cantidadEntradas > 0) {
                            final cartCubit =
                                BlocProvider.of<MovieCubit>(context);
                            cartCubit.restar(movie);
                          }
                        },
                      ),
                      Text(movie.cantidadEntradas.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          final cartCubit =
                              BlocProvider.of<MovieCubit>(context);
                          cartCubit.aumentar(movie);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      double totalAmount =
                          movie.precio * movie.cantidadEntradas;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => paginaDetalles(
                              movie: movie, totalAmount: totalAmount),
                        ),
                      );
                      final cartCubit =
                              BlocProvider.of<MovieCubit>(context);
                          cartCubit.confirmarCompra(movie);
                    },
                    child: Text('Confirmar Entradas'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
