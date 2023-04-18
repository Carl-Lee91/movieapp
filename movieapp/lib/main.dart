import 'dart:convert';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static const String popular = "popular";
  static const String nowPlay = "now-playing";
  static const String comingSoon = "coming-soon";

  static Future<List<PopularMovie>> getPopularMovies() async {
    List<PopularMovie> popularMovieInstances = [];
    final url = Uri.parse("$baseUrl/$popular");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> popularMovies = jsonDecode(response.body);
      for (var popularMovie in popularMovies["results"]) {
        final instance = PopularMovie.fromJson(popularMovie);
        popularMovieInstances.add(instance);
      }
      return popularMovieInstances;
    }
    throw Error();
  }

  static Future<List<NowPlayingMovie>> getNowPlayingMovies() async {
    List<NowPlayingMovie> nowPlayingMovieInstances = [];
    final url = Uri.parse("$baseUrl/$nowPlay");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> nowPlayingMovies = jsonDecode(response.body);
      for (var nowPlayingMovie in nowPlayingMovies["results"]) {
        final instance = NowPlayingMovie.fromJson(nowPlayingMovie);
        nowPlayingMovieInstances.add(instance);
      }
      return nowPlayingMovieInstances;
    }
    throw Error();
  }

  static Future<List<ComingSoonMovie>> getComingSoonMovies() async {
    List<ComingSoonMovie> comingSoonMovieInstances = [];
    final url = Uri.parse("$baseUrl/$comingSoon");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> comingSoonMovies = jsonDecode(response.body);
      for (var comingSoonMovie in comingSoonMovies["results"]) {
        final instance = ComingSoonMovie.fromJson(comingSoonMovie);
        comingSoonMovieInstances.add(instance);
      }
      return comingSoonMovieInstances;
    }
    throw Error();
  }

  static Future<MovieDetail> getMovieById(int id) async {
    final url = Uri.parse("$baseUrl/movie?id=$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final movieDetail = jsonDecode(response.body);
      return MovieDetail.fromJson(movieDetail);
    }
    throw Error();
  }
}

class PopularMovie {
  final String title, verticalPic;
  final String? horizontalPic;
  final int id;

  PopularMovie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        verticalPic = json["poster_path"],
        horizontalPic = json["backdrop_path"];
}

class NowPlayingMovie {
  final String title, verticalPic;
  final int id;

  NowPlayingMovie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        verticalPic = json["poster_path"];
}

class ComingSoonMovie {
  final String title, verticalPic;
  final int id;

  ComingSoonMovie.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        verticalPic = json["poster_path"];
}

class MovieDetail {
  final String title, verticalPic, homepage, overview;
  final int id, runningTime;
  final double vote;
  final List<Genres> genres;

  MovieDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        verticalPic = json["poster_path"],
        homepage = json["homepage"],
        overview = json["overview"],
        runningTime = json["runtime"],
        vote = json["vote_average"],
        genres = (json["genres"] as List<dynamic>)
            .map((genreJson) => Genres.fromJson(genreJson))
            .toList();
}

class Genres {
  final int id;
  final String name;

  Genres({required this.id, required this.name});

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(
      id: json['id'],
      name: json['name'],
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  Future<List<PopularMovie>> popularMovies = ApiService.getPopularMovies();
  Future<List<NowPlayingMovie>> nowPlayingMovies =
      ApiService.getNowPlayingMovies();
  Future<List<ComingSoonMovie>> comingSoonMovies =
      ApiService.getComingSoonMovies();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFE0E0E0),
          body: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Hot Now!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF5436),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: popularMovies,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var popularMovie = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                              title: popularMovie.title,
                                              verticalPic:
                                                  popularMovie.verticalPic,
                                              id: popularMovie.id),
                                          fullscreenDialog: true,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: 'popular_${popularMovie.id}',
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 15,
                                                    offset:
                                                        const Offset(10, 10),
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                  )
                                                ]),
                                            width: 250,
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.network(
                                              "https://image.tmdb.org/t/p/w500/${popularMovie.horizontalPic}",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          popularMovie.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF757E88),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 15,
                                ),
                                itemCount: snapshot.data!.length,
                              ),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Now in Cinemas!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF5436),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: nowPlayingMovies,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var nowPlayingMovies = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                              title: nowPlayingMovies.title,
                                              verticalPic:
                                                  nowPlayingMovies.verticalPic,
                                              id: nowPlayingMovies.id),
                                          fullscreenDialog: true,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag:
                                              'nowPlaying_${nowPlayingMovies.id}',
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 15,
                                                    offset:
                                                        const Offset(10, 10),
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                  )
                                                ]),
                                            width: 100,
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.network(
                                              "https://image.tmdb.org/t/p/w500/${nowPlayingMovies.verticalPic}",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            nowPlayingMovies.title,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF757E88),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 15,
                                ),
                                itemCount: snapshot.data!.length,
                              ),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Coming Soon!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF5436),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: comingSoonMovies,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var comingSoonMovies = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                              title: comingSoonMovies.title,
                                              verticalPic:
                                                  comingSoonMovies.verticalPic,
                                              id: comingSoonMovies.id),
                                          fullscreenDialog: true,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag:
                                              'comingSoon_${comingSoonMovies.id}',
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 15,
                                                    offset:
                                                        const Offset(10, 10),
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                  )
                                                ]),
                                            width: 100,
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.network(
                                              "https://image.tmdb.org/t/p/w500/${comingSoonMovies.verticalPic}",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            comingSoonMovies.title,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF757E88),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 15,
                                ),
                                itemCount: snapshot.data!.length,
                              ),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String title, verticalPic;
  final int id;
  const DetailScreen({
    super.key,
    required this.title,
    required this.verticalPic,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MovieDetail> movie;

  @override
  void initState() {
    super.initState();
    movie = ApiService.getMovieById((widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Back to list"),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: 700,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://image.tmdb.org/t/p/w500/${widget.verticalPic}",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Positioned.fill(
              right: 40,
              left: 15,
              top: 150,
              child: Column(
                children: [
                  FutureBuilder(
                    future: movie,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.title,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                'Rating : ${snapshot.data!.vote.round()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                '${snapshot.data!.genres.map((genre) => genre.name).join(", ")} / ${snapshot.data!.runningTime} mins',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Storyline",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                snapshot.data!.overview,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                child: const Text(
                                  "Get Ticket Now!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                onPressed: () async {
                                  await launchUrlString(
                                      snapshot.data!.homepage);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return const Text("...");
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
