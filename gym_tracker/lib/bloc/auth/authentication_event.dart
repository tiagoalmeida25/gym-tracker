part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final CustomUser user;

  LoggedIn({required this.user});
}

class LoggedOut extends AuthenticationEvent {}

class UpdateProfile extends AuthenticationEvent {
  final CustomUser user;
  final String username;
  final String gender;
  final int age;
  final int weight;
  final int height;
  final String? profilePictureUrl;

  UpdateProfile({
    required this.user,
    required this.username,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.profilePictureUrl,
  });
}
