import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginApi {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  signinWithGoogle() async {
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if(account != null){
      return account;
    }
  }

  checkRecentLogin() async {
    return await googleSignIn.signInSilently();
  }

  signOutGoogle() async {
    await googleSignIn.signOut();
  }
}