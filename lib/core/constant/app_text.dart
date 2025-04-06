import '../error/app_error.dart';

class AppText {
  static const String noInternetConnection = 'No Connection';
  static const String badE = 'Bad Request';
  static const String updateSuccessfully = 'Update Successfully';
  static const String invalidMobileNumber = 'Invalid Mobile Number';
  static const String loginSuccessfully = 'Login Successfully ';
  static const String successfully = 'Successfully';
  static const String successful = 'Successful';
  static const String otpSendSuccessfully =
      'Otp Send Successfully to your mobile Number';
  static const String otpSendToYourMobileNo = 'Otp send to your Mobile';
  static const String mobileNumberIsAlreadyExists =
      'Mobile Number is Already Exists';
  static const String somethingWentWrong = 'Something Went Wrong';
  static const String checkYourInternetConnection =
      'Check your internet connection';
  static const String tryAgainLater = 'Try Again Later';
  static const String badRequest = 'Bad Request';
  static const String invalidRequest = 'Invalid Request';
  static const String invalidOtp = 'Invalid Otp';
  static const String checkYourOtp = 'Check Your Otp';
  static const String checkYourCredential = 'Check Your Credential';
  static const String userNotExists = 'User Not Exists';
  static const String serverDown =
      'Oops! Looks like a hiccup. Give it a moment and try again shortly. Thanks for your patience!';
  static const String firstTime = 'First Time';
  static const String sessionOut = 'Session Expired. Please Login Again.';
  static const String validUser = 'valid user';
  static const String registrationIncompleteMessage =
      "User registration incomplete. Please log in again to complete your registration.";

  ///
  static const String otpSentSuccessfully = 'OTP sent successfully';
  static const String otpVerified = 'OTP verified';

  static const String userLoggedOut = 'User has been logged out';
}

class ErrorResponse {
  static const socketException =
      ErrorMessage(message: AppText.checkYourInternetConnection);
  static const somethingWentWrong =
      ErrorMessage(message: AppText.checkYourInternetConnection);
  static const timeOutException = ErrorMessage(message: AppText.tryAgainLater);
  static const formatException = ErrorMessage(message: AppText.badRequest);
  static const dioError = ErrorMessage(message: AppText.invalidRequest);
  static const sessionOut = ErrorMessage(message: AppText.sessionOut);
  static const otherException =
      ErrorMessage(message: AppText.somethingWentWrong);
}
