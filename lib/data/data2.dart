library hudra_mobile.data2;

// import 'package:hudra/utils/hexColor/hexColor.dart';
// import 'package:flutter/material.dart';

//Version
const String version = "v1.0";

//Server Ip  (view[/my_api.dart])
// const String myIP = "https://kwikcode.net/hudra_php";

List<String> currentPageList = [
  'DailyPage',
  'CalendarPage',
  // 'HolidayPrayerPage',
  'RitualsPage',
  'PrayersPage',
  'BiblePage',
  'SettingsPage',
  'DiscoverPage',
  'NotificationsPage',
  'SavedVersesPage',
  'InfoPage',
  // 'ErrorPage'
];

//Errors
const String warning1 = "No Spaces Allowed.";
const String warning2_1 = "Your username must contain at least 8 characters.";
const String warning2_2 =
    "Your username can only contain lowercase and uppercase characters and special characters( _ .).";
const String warning2_3 =
    "Your password must contain at least 8 characters, 1 lowercase(a-z),1 uppercase(A-Z),1 numeric character(0-9) and 1 special character(* . ! @ # \$ % ^ & : , ? _ -).";
//const String warning2_4 = "Your age must be greater than 17.";
const String warning2_5 = "It's not an email format.";
//const String warning2_6 = "It's not a university email.";
const String error2_7 = "phone Number already exists";
const String error3 = "Please make sure your passwords match.";
const String error4 =
    "Cannot connect to the dataBase."; // error in insert or delete or update etc...
const String warning5 = "UserName already exist.";
const String warning6 = "Email already exist.";
const String warning7 = "Field cannot be empty.";
const String warning8 = "Incorrect email or password."; // for login
const String error9 = "It's not a phoneNumber format, example: +961########";
const String warning10 = "No data available";
const String error11 = "This email is not Registered";
const String error12 = "Incorrect Email sent";
const String errorToken = "Token Error.";
const String errorVersion = "New version available.";
const String errorElse = "Failed to connect... Connection Problem.";
const String errorException =
    "OOPs! Something went wrong. Try again in few seconds.";
const String codeFailed = "your code is incorrect";
const String codeException =
    "Oops Something went wrong! please try to login again!";

const String warning400 = "You must login first!"; ///////
const String error401 = "Sorry, this day is full."; ///////
const String error402 = "Sorry, this day is not available."; ///////
const String error403 = "Sorry, this course is not available."; ///////
const String success404 = "New course added."; ///////
const String error405 = 'This teacher has no courses yet.';
const String error406 = 'There is no courses available on this day.';
const String warning407 = 'There is no teacehrs available.';
const String success408 = "Payment Done Successfully."; ///////
const String error409 = 'Coupon already claimed!';
const String error410 = 'You don\'t have enough bill.'; // Wallet doesn't Exists
const String error411 = 'You don\'t have enough bill.';
const String error412 = 'The course is no longer available.';
const String error413 = 'You already have this course.';
