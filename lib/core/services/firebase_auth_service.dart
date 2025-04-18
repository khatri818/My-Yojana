import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthService {
  Future<void> sendOtp(
    String phoneNumber,
    Duration timeOut,
    PhoneVerificationFailed phoneVerificationFailed,
    PhoneVerificationCompleted phoneVerificationCompleted,
    PhoneCodeSent phoneCodeSent,
    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
  );

  Future<UserCredential> verifyAndLogin(String verificationId, String smsCode);

  Future<UserCredential?> signInWithGoogle();

  User? getUser();

  Future<void> resendOtp(
    String phoneNumber,
    Duration timeOut,
    String verificationId,
    int resendToken,
    PhoneVerificationFailed phoneVerificationFailed,
    PhoneVerificationCompleted phoneVerificationCompleted,
    PhoneCodeSent phoneCodeSent,
    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
  );

  Future<void> logout();
}

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthServiceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Future<void> sendOtp(
    String phoneNumber,
    Duration timeOut,
    PhoneVerificationFailed phoneVerificationFailed,
    PhoneVerificationCompleted phoneVerificationCompleted,
    PhoneCodeSent phoneCodeSent,
    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeOut,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  @override
  Future<UserCredential> verifyAndLogin(
      String verificationId, String smsCode) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await _firebaseAuth.signInWithCredential(authCredential);
  }

  @override
  Future<void> resendOtp(
    String phoneNumber,
    Duration timeOut,
    String verificationId,
    int resendToken,
    PhoneVerificationFailed phoneVerificationFailed,
    PhoneVerificationCompleted phoneVerificationCompleted,
    PhoneCodeSent phoneCodeSent,
    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeOut,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
      forceResendingToken: resendToken,
    );
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  @override
  User? getUser() {
    return _firebaseAuth.currentUser;
  }
  
  @override
  Future<void> logout() async  {
    await _firebaseAuth.signOut();
  }
}
