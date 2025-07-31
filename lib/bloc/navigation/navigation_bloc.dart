import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/navigation/navigation_event.dart';
import 'package:ayubolife/bloc/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(selectedIndex: 0)) {
    on<NavigationItemSelected>(_onNavigationItemSelected);
  }

  void _onNavigationItemSelected(NavigationItemSelected event, Emitter<NavigationState> emit) {
    emit(NavigationState(selectedIndex: event.index));
  }
}