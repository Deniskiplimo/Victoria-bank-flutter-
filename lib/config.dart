import 'dart:convert';
<<<<<<< HEAD
import 'package:http/http.dart' as http;

/// Configurations for API URLs and responses
class Config {
  // Base URLs for different services
  static const String baseUrl = 'https://yourapi.com/api'; // Replace with your actual API base URL
  static const String accountServiceBaseUrl = '$baseUrl/account_service';
  static const String authServiceBaseUrl = '$baseUrl/auth_service';
=======
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'DashboardScreen.dart';
import 'LoginScreen.dart';
import 'PasswordResetScreen.dart';

/// Configurations for API URLs and responses
class Config {
  // Base URLs for different services

  static const String baseUrl = 'http://102.210.244.222:6508';  // Updated with your actual API base URL
  static const String accountServiceBaseUrl = '$baseUrl/account/account/';
  static const String authServiceBaseUrl = '$baseUrl/authentication';
>>>>>>> 385577e (ok)
  static const String mpesaServiceBaseUrl = '$baseUrl/mpesa_service';
  static const String bioServiceBaseUrl = '$baseUrl/bio_service';
  static const String otpServiceBaseUrl = '$baseUrl/otp_service';

  // Endpoints for different services
<<<<<<< HEAD
  static const String getAccountCategoriesEndpoint = '$accountServiceBaseUrl/account_categories';
  static const String resetPasswordEndpoint = '$authServiceBaseUrl/reset_password';
=======
  static const String getAccountCategoriesEndpoint = '$accountServiceBaseUrl/account/account';
  static const String resetPasswordEndpoint = '$baseUrl/authentication/setPassword';
>>>>>>> 385577e (ok)
  static const String someOtherServiceEndpoint = '$baseUrl/some_other_service';
  static const String initiateMpesaPromptEndpoint = '$mpesaServiceBaseUrl/initiate';
  static const String biometricAuthEndpoint = '$bioServiceBaseUrl/authenticate';
  static const String sendOtpEndpoint = '$otpServiceBaseUrl/send';
  static const String verifyOtpEndpoint = '$otpServiceBaseUrl/verify';
  static const String transferFundsEndpoint = '$accountServiceBaseUrl/transfer_funds';
  static const String withdrawFundsEndpoint = '$accountServiceBaseUrl/withdraw_funds';
<<<<<<< HEAD
  static const String fetchAccountsEndpoint = '$accountServiceBaseUrl/fetch_accounts';
  static const String fetchCreditAccountsEndpoint = '$accountServiceBaseUrl/credit_accounts';  // New endpoint
  static const String fetchLoanAccountsEndpoint = '$accountServiceBaseUrl/loan_accounts';      // New endpoint
  static const String fetchFixedAccountsEndpoint = '$accountServiceBaseUrl/fixed_accounts';    // New endpoint
  static const String transactionsEndpoint = '$accountServiceBaseUrl/transactions'; // Endpoint for fetching transactions

  // Common HTTP headers
  static Map<String, String> commonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    // Add other common headers here if needed
=======
  static const String fetchAccountsEndpoint = '$accountServiceBaseUrl/account/account';
  static const String fetchCreditAccountsEndpoint = '$accountServiceBaseUrl/credit_accounts';  // New endpoint
  static const String fetchLoanAccountsEndpoint = '$accountServiceBaseUrl/account/account';      // New endpoint
  static const String fetchFixedAccountsEndpoint = '$accountServiceBaseUrl/account/account';    // New endpoint
  static const String transactionsEndpoint = '$accountServiceBaseUrl/transactions'; // Endpoint for fetching transactions
  static const String loginEndpoint = '$authServiceBaseUrl/login'; // Correct login endpoint
  static const String signupEndpoint = '$authServiceBaseUrl/add-user'; // Sign up endpoint
  static const String fetchAccountDetailsEndpoint = '$accountServiceBaseUrl/account/account'; // New endpoint for fetching account details
  static const String setBiometricAuthEndpoint = '$baseUrl/authentication/setBio/{request}/{userId}'; // Endpoint for setting biometric authentication
  static const String logoutEndpoint = '$baseUrl/authentication/logout';
  
  // Common HTTP headers
  static Map<String, String> commonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': '*/*',  // Added Accept header for API requests
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': '*/*',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
>>>>>>> 385577e (ok)
  };

  // Handle common API errors
  static void handleApiError(dynamic e) {
    // Handle API errors globally
    print('API Error: $e');
    // You can extend this to show dialogs, log errors, etc.
  }

  // Fetch Transactions
  static Future<TransactionResponse> fetchTransactions() async {
    try {
      final response = await http.get(
        Uri.parse(transactionsEndpoint),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        // Parse the response
        return TransactionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

<<<<<<< HEAD
  // Fetch Accounts
  static Future<List<Account>> fetchAccounts() async {
    try {
      final response = await http.get(
        Uri.parse(fetchAccountsEndpoint),
=======
  // Fetch Accounts by CIF
  static Future<List<Account>> fetchAccountsByCif(String cif) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/account/account/$cif'),
>>>>>>> 385577e (ok)
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
<<<<<<< HEAD
        List<dynamic> body = jsonDecode(response.body);
        List<Account> accounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return accounts;
=======
        final data = json.decode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch accounts: ${data['message']}');
        }
>>>>>>> 385577e (ok)
      } else {
        throw Exception('Failed to load accounts');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Fetch Credit Accounts
  static Future<List<Account>> fetchCreditAccounts() async {
    try {
      final response = await http.get(
<<<<<<< HEAD
        Uri.parse(fetchCreditAccountsEndpoint),
=======
        Uri.parse('$baseUrl/account/account'), // Replace with your actual credit accounts endpoint
>>>>>>> 385577e (ok)
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
<<<<<<< HEAD
        List<dynamic> body = jsonDecode(response.body);
        List<Account> creditAccounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return creditAccounts;
=======
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch credit accounts: ${data['message']}');
        }
>>>>>>> 385577e (ok)
      } else {
        throw Exception('Failed to load credit accounts');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Fetch Loan Accounts
  static Future<List<Account>> fetchLoanAccounts() async {
    try {
      final response = await http.get(
<<<<<<< HEAD
        Uri.parse(fetchLoanAccountsEndpoint),
=======
        Uri.parse('$baseUrl/account/account'), // Replace with your actual loan accounts endpoint
>>>>>>> 385577e (ok)
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
<<<<<<< HEAD
        List<dynamic> body = jsonDecode(response.body);
        List<Account> loanAccounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return loanAccounts;
=======
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch loan accounts: ${data['message']}');
        }
>>>>>>> 385577e (ok)
      } else {
        throw Exception('Failed to load loan accounts');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Fetch Fixed Accounts
  static Future<List<Account>> fetchFixedAccounts() async {
    try {
      final response = await http.get(
<<<<<<< HEAD
        Uri.parse(fetchFixedAccountsEndpoint),
=======
        Uri.parse('$baseUrl/account/account'), // Replace with your actual fixed accounts endpoint
>>>>>>> 385577e (ok)
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
<<<<<<< HEAD
        List<dynamic> body = jsonDecode(response.body);
        List<Account> fixedAccounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return fixedAccounts;
=======
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch fixed accounts: ${data['message']}');
        }
>>>>>>> 385577e (ok)
      } else {
        throw Exception('Failed to load fixed accounts');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

<<<<<<< HEAD
  // Send OTP
  static Future<void> sendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(sendOtpEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP');
=======
  // Fetch Account Details
  static Future<Map<String, dynamic>> fetchAccountDetails(String accountId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/account/account'), // Replace with your actual account details endpoint
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          return data['entity'];
        } else {
          throw Exception('Failed to fetch account details: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load account details');
>>>>>>> 385577e (ok)
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

<<<<<<< HEAD
  // Verify OTP
  static Future<bool> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(verifyOtpEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'phone_number': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['verified'] as bool;
      } else {
        throw Exception('Failed to verify OTP');
=======

  static Future<void> sendOtp(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authentication/sendOtp/$userId'), // Ensure this URL is correct
        headers: commonHeaders,
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        throw Exception('Sending OTP failed: ${responseBody['message']}');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  static Future<bool> verifyOtp(String userId, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authentication/verifyOTP'), // Ensure this URL is correct
        headers: commonHeaders,
        body: jsonEncode({'userId': userId, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('OTP verification failed: ${responseBody['message']}');
>>>>>>> 385577e (ok)
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Initiate M-Pesa Prompt
  static Future<void> initiateMpesaPrompt(String accountId, String phoneNumber, double amount) async {
    try {
      final response = await http.post(
        Uri.parse(initiateMpesaPromptEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'account_id': accountId,
          'phone_number': phoneNumber,
          'amount': amount,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to initiate M-Pesa prompt');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Authenticate Biometric
  static Future<bool> authenticateBiometric(String username) async {
    try {
      final response = await http.post(
        Uri.parse(biometricAuthEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['authenticated'] as bool;
      } else {
        throw Exception('Failed to authenticate biometrically');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Transfer Funds
  static Future<void> transferFunds(String fromAccountId, String toAccountId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse(transferFundsEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'from_account_id': fromAccountId,
          'to_account_id': toAccountId,
          'amount': amount,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to transfer funds');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Withdraw Funds
  static Future<void> withdrawFunds(String accountId, String phoneNumber, double amount) async {
    try {
      final response = await http.post(
        Uri.parse(withdrawFundsEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'account_id': accountId,
          'phone_number': phoneNumber,
          'amount': amount,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to withdraw funds');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }
<<<<<<< HEAD
=======

  // Authenticate User
  static Future<Map<String, dynamic>> authenticateUser(String userId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/login'),  // API endpoint for login
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;  // Return the entire response JSON
    } else {
      throw Exception('Failed to authenticate user');
    }
  }

  // Reset password with old password and confirmation of the new password
  // Reset password with old password and confirmation of the new password
  static Future<String> resetPassword(String userId, String oldPassword, String newPassword, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/setPassword'),  // Update to your actual API endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Assuming success response contains a message
      final responseBody = json.decode(response.body);
      if (responseBody['message'] != null) {
        return responseBody['message'];
      } else {
        return 'Password reset successfully';
      }
    } else {
      throw Exception('Failed to reset password: ${response.body}');
    }
  }

  // Existing methods
  static Future<String> getSecurityQuestion(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/securityQuestion/security/random-questions?userId=$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isEmpty) {
        throw Exception('No security question found.');
      }
      return data[0]['question']['questionText'];
    } else {
      throw Exception('Failed to fetch security question');
    }
  }

  static Future<bool> verifySecurityAnswer(String userId, List<int> questionIds, List<String> answers) async {
    final response = await http.post(
      Uri.parse('$baseUrl/securityQuestion/security/verify-answers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'questionIds': questionIds,
        'userProvidedAnswers': answers,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Security question verification failed');
    }
  }

  static Future<bool> addSecurityAnswers(String userId, List<Map<String, dynamic>> answers) async {
    final response = await http.post(
      Uri.parse('$baseUrl/securityQuestion/addMultipleAnswers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(answers),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add security answers');
    }
  }


  // Sign Up User
  static Future<User> signUpUser(int roleId, String userId, String cif) async {
    try {
      final response = await http.post(
        Uri.parse(signupEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'roleId': roleId,
          'userId': userId,
          'cif': cif,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        return User.fromSignUpJson(responseBody);
      } else {
        // Handle specific status codes
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['statusCode'] == 400) {
          throw Exception('Bad Request: ${responseBody['message']}');
        } else {
          throw Exception('Failed to sign up user');
        }
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Set Biometric Authentication
  static Future<void> setBiometricAuthentication(String request, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$setBiometricAuthEndpoint/$request/$userId'),
        headers: commonHeaders,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to set biometric authentication');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }



  static Future<void> logout(String accessToken) async {
    final url = Uri.parse('$baseUrl$logoutEndpoint');

    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'accessToken': accessToken,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully logged out
      print('Logout successful');
    } else {
      // Handle error
      throw Exception('Failed to logout: ${response.reasonPhrase}');
    }
  }


  // Existing methods
}
Future<void> _logout(BuildContext context) async {
  final String accessToken = await _getAccessToken(); // Retrieve the access token from shared preferences

  try {
    await Config.logout(accessToken);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout failed')),
    );
  }
}

_getAccessToken() {
}
// Define User Model
class User {
  final String token;
  final String userId;
  final String role;
  final String cif; // Added cif for sign-up response
  final bool bioEnabled; // Added bioEnabled for user biometric status

  User({
    required this.token,
    required this.userId,
    required this.role,
    required this.cif,
    required this.bioEnabled,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      cif: json['cif'] as String,
      bioEnabled: json['bio_enabled'] as bool, // Added to handle bio status
    );
  }

  factory User.fromSignUpJson(Map<String, dynamic> json) {
    return User(
      token: json['entity']['userId'] as String,
      userId: json['entity']['userId'] as String,
      role: json['entity']['role']['name'] as String,
      cif: json['entity']['cif'] as String,
      bioEnabled: json['entity']['bioEnabled'] as bool, // Added to handle bio status
    );
  }
>>>>>>> 385577e (ok)
}

// Define Transaction Response Model
class TransactionResponse {
  final List<Transaction> transactions;

  TransactionResponse({required this.transactions});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['transactions'] as List;
    List<Transaction> transactionsList =
    list.map((i) => Transaction.fromJson(i)).toList();

    return TransactionResponse(transactions: transactionsList);
  }
}

class Transaction {
  final String type;
  final String amount;

<<<<<<< HEAD
=======
  static var baseUrl;

  

>>>>>>> 385577e (ok)
  Transaction({required this.type, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'] as String,
      amount: json['amount'] as String,
    );
  }
<<<<<<< HEAD
}

// Define Account Model
class Account {
  final int id;
  final String name;

  Account({required this.id, required this.name});
=======

// Fetch Account Details for the example CIF
  // Fetch accounts by CIF
  static Future<List<Account>> fetchAccountsByCif(String cif) async {
    final url = Uri.parse('$baseUrl/account/account/$cif');

    final response = await http.get(url, headers: {
      'accept': '*/*',
      'Authorization': 'Bearer $apiToken', // Replace $apiToken with your actual token
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['statusCode'] == 200) {
        final List<dynamic> accountsJson = data['entity'];
        return accountsJson.map((json) => Account.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch accounts: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  // Define other methods and configurations as needed

  // Replace with your actual API token
  static const String apiToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjgzYTM1OTliOGU0YjAxZTI1YjUyNDciLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3MTk5MTA3MzAsImV4cCI6MTcxOTkxNDMzMH0.Fbj9SkLHhPc-NlFG0BDpHr3q-VlYgvZVKAI3PsPHrlA';
}

// Model class for Account
class Account {
  final int id;
  final String accountName;
  final String accountNumber;
  final String schemeCode;
  final String schemeType;
  final String accountOpeningDate;
  final String currency;
  final String cif;

  String name;

  var balance;

  var type;

  Account({
    required this.id,
    required this.name,
    required this.accountName,
    required this.accountNumber,
    required this.schemeCode,
    required this.schemeType,
    required this.accountOpeningDate,
    required this.currency,
    required this.cif,
  });
>>>>>>> 385577e (ok)

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
<<<<<<< HEAD
      name: json['name'],
    );
  }
}
=======
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      schemeCode: json['schemeCode'],
      schemeType: json['schemeType'],
      accountOpeningDate: json['accountOpeningDate'],
      currency: json['currency'],
      cif: json['cif'], name: '',
    );
  }
}
>>>>>>> 385577e (ok)
