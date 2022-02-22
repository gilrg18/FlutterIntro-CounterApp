import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '02011706ae26c52811568a92a0c2f8ab';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  MoviesProvider() {
    print('MoviesProvider inicializado');
    getOnDisplayMovies();
    getPopularMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });
    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);

    //print(decodedData['dates']);
    //print('Movie Title: ${nowPlayingResponse.results[1].title}');
    onDisplayMovies = nowPlayingResponse.results;
    //redibuja los widgets que utilizan la data al momento de que cambie la data
    notifyListeners();
  }

  getPopularMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });
    final response = await http.get(url);
    final popularResponse = PopularResponse.fromJson(response.body);
    //destructurar popularResponse para ir guardando todo en popular movies
    //sin que se sobreescriba (... operador spread)
    popularMovies = [...popularMovies, ...popularResponse.results];
    //print(popularMovies[0]);
    notifyListeners();
  }
}
