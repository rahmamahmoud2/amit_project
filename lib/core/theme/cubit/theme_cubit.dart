import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(mode: ThemeMode.light));

  void toggleTheme() {
    final newMode =
        state.mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(mode: newMode));
  }
}
