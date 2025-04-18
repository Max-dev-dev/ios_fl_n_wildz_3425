import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/models/map_place_model.dart';

class MapPlaceCubit extends Cubit<List<MapPlaceModel>> {
  MapPlaceCubit() : super(_initialPlaces);

   static final List<MapPlaceModel> _initialPlaces = [
    MapPlaceModel(
      name: 'Pine Barrens Trail',
      description: 'A scenic trail through the dense pine forests of southern NJ.',
      latitude: '38.8007922',
      longitude: '-76.6957404',
      weather: 'Sunny',
      photos: [],
    ),
    MapPlaceModel(
      name: 'Ramapo Valley County Reservation',
      description: 'Popular trail with a lake, rivers, and rocky outcrops near Mahwah.',
      latitude: '41.0802812',
      longitude: '-74.2015013',
      weather: 'Fog',
      photos: [],
    ),
    MapPlaceModel(
      name: 'Watchung Reservation Trail',
      description: 'Wooded hiking area with rustic bridges and marshland.',
      latitude: '40.6816634',
      longitude: '-74.3837095',
      weather: 'Rain',
      photos: [],
    ),
  ];

  void addPlace(MapPlaceModel place) {
    final updated = List<MapPlaceModel>.from(state)..add(place);
    emit(updated);
  }

  void deletePlace(MapPlaceModel place) {
    final updated = List<MapPlaceModel>.from(state)..remove(place);
    emit(updated);
  }
}
