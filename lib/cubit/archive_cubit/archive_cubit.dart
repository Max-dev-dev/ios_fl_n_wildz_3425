import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/models/nature_model.dart';
import 'package:logger/logger.dart';

class ArchiveCubit extends Cubit<List<NatureModel>> {
  ArchiveCubit() : super([]);

  void addToArchive(NatureModel nature) {
    Logger().i('Adding to archive: ${nature.name}');
    final updated = List<NatureModel>.from(state)..add(nature);
    emit(updated);
  }
}
