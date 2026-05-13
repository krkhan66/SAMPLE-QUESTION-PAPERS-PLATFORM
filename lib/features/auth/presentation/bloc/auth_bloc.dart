import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = UserEntity(
        id: '1',
        name: 'John Doe',
        email: event.email,
        createdAt: DateTime.now(),
      );

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = UserEntity(
        id: '1',
        name: event.name,
        email: event.email,
        createdAt: DateTime.now(),
      );

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      clearUser: true,
    ));
  }

  void _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = state.user != null
          ? UserEntity(
              id: state.user!.id,
              name: event.name,
              email: state.user!.email,
              avatarUrl: event.avatarUrl,
              createdAt: state.user!.createdAt,
            )
          : null;

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
