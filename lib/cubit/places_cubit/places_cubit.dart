import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/models/place_model.dart';

class PlaceCubit extends Cubit<List<PlaceModel>> {
  PlaceCubit()
    : super([
        PlaceModel(
          name: 'Forest Haven',
          description: 'A peaceful forest clearing surrounded by old pines.',
          coordinates: '39.908556,-75.117168',
          weather: 'Sunny',
          photos: [File('assets/images/forest1.png')],
          colors: [],
          textures: [],
          naturalObjects: [],
          landscapeType: 'Forest',
        ),
        PlaceModel(
          name: 'Whispering Pines',
          description:
              'Tall pine trees gently rustle in the wind creating a soothing soundscape.',
          coordinates: '40.732013,-74.007228',
          weather: 'Wind',
          photos: [File('assets/images/forest1.png')],
          colors: [],
          textures: [],
          naturalObjects: [],
          landscapeType: 'Forest',
        ),
        PlaceModel(
          name: 'Emerald Glade',
          description:
              'A hidden green glade deep inside the forest, ideal for quiet walks.',
          coordinates: '41.203323,-77.194527',
          weather: 'Rain',
          photos: [File('assets/images/forest1.png')],
          colors: [],
          textures: [],
          naturalObjects: [],
          landscapeType: 'Forest',
        ),
        PlaceModel(
          name: 'Shadowgrove',
          description:
              'Darker, denser part of the forest with massive old trees.',
          coordinates: '38.907192,-77.036871',
          weather: 'Fog',
          photos: [File('assets/images/forest1.png')],
          colors: [],
          textures: [],
          naturalObjects: [],
          landscapeType: 'Forest',
        ),
        PlaceModel(
          name: 'Deer Hollow',
          description:
              'Forest clearing where deer are often spotted early in the morning.',
          coordinates: '34.052235,-118.243683',
          weather: 'Clear',
          photos: [File('assets/images/forest1.png')],
          colors: [],
          textures: [],
          naturalObjects: [],
          landscapeType: 'Forest',
        ),
      ]);

  void addPlace(PlaceModel place) {
    emit([...state, place]);
  }

  void deletePlace(PlaceModel place) {
    emit(state.where((p) => p != place).toList());
  }
}
