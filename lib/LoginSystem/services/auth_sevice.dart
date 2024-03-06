import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceGoogle {
  GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '1019803507870-7lrp1ff7c0de4mt317nto9esbidsgaes'
);
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
