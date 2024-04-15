import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/model/user.dart';
import 'package:gym_tracker/repositories/repository.dart';

import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationUninitialized()) {
    on<AppStarted>((event, emit) async {
      final currentUser = _userRepository.getCurrentUser();
      if (currentUser != null) {
        emit(AuthenticationAuthenticated(
          user: CustomUser(
            id: currentUser.uid,
            email: currentUser.email!,
            username: currentUser.displayName!,
            profilePictureUrl: currentUser.photoURL,
          ),
        ));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationAuthenticated(user: event.user));
    });

    on<LoggedOut>((event, emit) async {
      await _userRepository.signOut();
      emit(AuthenticationUnauthenticated());
    });

    on<UpdateProfile>((event, emit) async {
      try {
        emit(AuthenticationLoading());
        _userRepository.updateProfile(
          event.user,
          event.username,
          event.age,
          event.weight,
          event.height,
          event.gender,
          event.profilePictureUrl,
        );
        emit(AuthenticationSuccess(message: 'Profile updated successfully'));
      } catch (e) {
        emit(AuthenticationFailure(message: e.toString()));
      }
    });
  }
}
