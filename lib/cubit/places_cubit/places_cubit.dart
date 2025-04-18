import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/models/place_model.dart';

class PlaceCubit extends Cubit<List<PlaceModel>> {
  PlaceCubit() : super([]);

  void addPlace(PlaceModel place) {
    emit([...state, place]);
  }

  void deletePlace(PlaceModel place) {
    emit(state.where((p) => p != place).toList());
  }
}
