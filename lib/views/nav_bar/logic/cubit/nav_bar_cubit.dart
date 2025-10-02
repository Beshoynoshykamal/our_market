import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'nav_bar_state.dart';

class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit() : super(NavBarInitial());
  int currentIndex = 0;
  void changedCurrentIndex(int index) {
    currentIndex = index;
    emit(IndexChanged());
  }
}
