import 'package:firebase_auth/firebase_auth.dart';

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

  FirebaseAuthServiceImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

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
  User? getUser() {
    return _firebaseAuth.currentUser;
  }
  
  @override
  Future<void> logout() async  {
    await _firebaseAuth.signOut();
  }
}
