import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../model/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  Future<auth.User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(auth.GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
        return userCredential.user;
      }
    } else {
      throw auth.FirebaseAuthException(code: 'ERROR_ABORDER_BY_USER', message: 'Sign in aborder by user');
    }
  }


Future<auth.User?> signInWithApple(BuildContext context) async {
  final AuthorizationResult result = await TheAppleSignIn.performRequests([
    AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  ]);

  switch (result.status) {
    case AuthorizationStatus.authorized:
      final AppleIdCredential? _auth = result.credential;
      final auth.OAuthProvider oAuthProvider = auth.OAuthProvider("apple.com");

      final auth.AuthCredential credential = oAuthProvider.credential(
        idToken: String.fromCharCodes(_auth!.identityToken as Iterable<int>),
        accessToken: String.fromCharCodes(_auth.authorizationCode as Iterable<int>),
      );

      await auth.FirebaseAuth.instance.signInWithCredential(credential);

      // Update the user information
      if (_auth.fullName != null) {
        final String? firstName = _auth.fullName!.givenName;
        final String? lastName = _auth.fullName!.familyName;
        final String? email = auth.FirebaseAuth.instance.currentUser!.email;

        print('First Name: $firstName');
        print('Last Name: $lastName');
        print('Email: $email');
      } else {
        // If the user didn't provide their full name, you can handle it here.
        print('User did not provide full name.');
      }

      break;

    case AuthorizationStatus.error:
      print("Sign In Failed ${result.error?.localizedDescription}");
      break;

    case AuthorizationStatus.cancelled:
      print("User Cancelled");
      break;
  }
}

  /* Future<auth.User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      if (appleCredential == null) {
        throw Exception('Errore durante l\'autenticazione con Apple');
      }

      final oauthCredential = auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      print(userCredential.user!.displayName);

      return userCredential.user; // restituisci un'istanza di UserCredential in caso di successo
    } on PlatformException catch (error) {
      print(error);
      throw Exception('Errore durante l\'autenticazione con Apple'); // lancia un'eccezione in caso di errore
    } catch (error) {
      print(error);
      throw Exception('Errore durante l\'autenticazione con Apple'); // lancia un'eccezione in caso di errore
    }
  }*/

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser!).uid;
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<User?> signUpUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } on auth.FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
