import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Stream to listen to auth state changes
  Stream<User?> get userStream => _auth.authStateChanges();

  // Register with email and password
  Future<UserModel?> register(String name, String phone, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        UserModel newUser = UserModel(
          id: firebaseUser.uid,
          name: name,
          phone: phone,
          email: email,
        );
        // Save user data to Firestore
        await _firestoreService.saveUser(newUser);
        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      print('Registration Error: ${e.message}');
      rethrow;
    }
    return null;
  }

  // Login with email and password
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        // Fetch user data from Firestore
        return await _firestoreService.getUser(firebaseUser.uid);
      }
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.message}');
      rethrow;
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return await _firestoreService.getUser(firebaseUser.uid);
    }
    return null;
  }
}
