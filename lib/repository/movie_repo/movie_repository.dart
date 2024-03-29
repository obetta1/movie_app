import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:movi_app/model/movies.dart';
import 'package:movi_app/repository/movie_repo/base_movie_repository.dart';

import '../local_storage_repository.dart';

class MovieRepository extends BaseMovieRepository{
  final FirebaseFirestore _firebaseFirestore;
  final CollectionReference _movieDetails = FirebaseFirestore.instance.collection('ben');
  final LocalStorageRepository localStorageRepository = LocalStorageRepository();

  MovieRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;


  @override
  Stream<Movies> getMovie(String movieId) {
    return _firebaseFirestore.collection('movies')
        .doc(movieId).snapshots().map((snap) => Movies.fromSnapshot(snap));
  }

  @override
  Stream<List<Movies>> getAllMovie()  {
   var movie = _firebaseFirestore.collection('movies').snapshots().map((snap) {
     return snap.docs.map((doc) => Movies.fromSnapshot(doc)).toList();});

   return movie;
  }

  @override
  Future<void> addMovie(Movies movie) {
   return _firebaseFirestore.collection('movies').add(movie.toSnapshot());
  }

  @override
  Future<void> deleteMovie(String movieId) async {
    await _firebaseFirestore.collection('movies').doc(movieId).delete();
  }



}