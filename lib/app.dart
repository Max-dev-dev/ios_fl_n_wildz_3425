import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/archive_cubit/archive_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/map_place_cubit/map_place_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/places_cubit/places_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/loading_screen/loading_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color mainBackgroundColor = const Color(0xFF412786);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ArchiveCubit()),
        BlocProvider(create: (context) => PlaceCubit()),
        BlocProvider(create: (context) => MapPlaceCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: mainBackgroundColor,
          appBarTheme: AppBarTheme(backgroundColor: mainBackgroundColor),
        ),
        home: LoadingScreen(),
      ),
    );
  }
}
