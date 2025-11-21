import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/repositories/auth_repository.dart';
import 'base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  late final AuthRepository _repository;

  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthViewModel() {
    _repository = AuthRepository(
      FirebaseAuth.instance,
      GoogleSignIn(),
    );

    _repository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
    _user = _repository.currentUser;
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    setLoading(true);
    clearError();

    try {
      await _repository.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      _user = _repository.currentUser;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    setLoading(true);
    clearError();

    try {
      await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = _repository.currentUser;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    clearError();

    try {
      await _repository.signInWithGoogle();
      _user = _repository.currentUser;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      setError('Erreur déconnexion : $e');
    }
  }
}
