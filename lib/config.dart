import 'dart:convert';
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
  static const String mpesaServiceBaseUrl = '$baseUrl/mpesa_service';
  static const String bioServiceBaseUrl = '$baseUrl/bio_service';
  static const String otpServiceBaseUrl = '$baseUrl/otp_service';

  // Endpoints for different services
  static const String getAccountCategoriesEndpoint = '$accountServiceBaseUrl/account_categories';
  static const String resetPasswordEndpoint = '$baseUrl/authentication/setPassword';
  static const String someOtherServiceEndpoint = '$baseUrl/some_other_service';
  static const String initiateMpesaPromptEndpoint = '$mpesaServiceBaseUrl/initiate';
  static const String biometricAuthEndpoint = '$bioServiceBaseUrl/authenticate';
  static const String sendOtpEndpoint = '$otpServiceBaseUrl/send';
  static const String verifyOtpEndpoint = '$otpServiceBaseUrl/verify';
  static const String transferFundsEndpoint = '$accountServiceBaseUrl/transfer_funds';
  static const String withdrawFundsEndpoint = '$accountServiceBaseUrl/withdraw_funds';
  static const String fetchAccountsEndpoint = '$accountServiceBaseUrl/account/account';
  static const String fetchCreditAccountsEndpoint = '$accountServiceBaseUrl/credit_accounts';  // New endpoint
  static const String fetchLoanAccountsEndpoint = '$accountServiceBaseUrl/loan_accounts';      // New endpoint
  static const String fetchFixedAccountsEndpoint = '$accountServiceBaseUrl/fixed_accounts';    // New endpoint
  static const String transactionsEndpoint = '$accountServiceBaseUrl/transactions'; // Endpoint for fetching transactions
  static const String loginEndpoint = '$authServiceBaseUrl/login'; // Correct login endpoint
  static const String signupEndpoint = '$authServiceBaseUrl/add-user'; // Sign up endpoint
  static const String fetchAccountDetailsEndpoint = '$accountServiceBaseUrl/account/account'; // New endpoint for fetching account details
  static const String setBiometricAuthEndpoint = '$baseUrl/authentication/setBio/{request}/{userId}'; // Endpoint for setting biometric authentication
  static const String logoutEndpoint = '$baseUrl/authentication/logout';

  // New endpoints
  static const String verifySecurityAnswerEndpoint = '$authServiceBaseUrl/verifySecurityAnswer';  // New endpoint
  static const String getSecurityQuestionEndpoint = '$authServiceBaseUrl/getSecurityQuestion';  // New endpoint
  static const String authenticateBiometricEndpoint = '$bioServiceBaseUrl/authenticateBiometric';  // New endpoint
  static const String authenticateUserEndpoint = '$authServiceBaseUrl/authenticateUser';  // New endpoint
  static const String signUpUserEndpoint = '$authServiceBaseUrl/signUpUser';  // New endpoint

  // Common HTTP headers
  static Map<String, String> commonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': '*/*',  // Added Accept header for API requests
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
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

  // Fetch Accounts by CIF
  static Future<List<Account>> fetchAccountsByCif(String cif) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/account/account/$cif'),
        headers: commonHeaders,
      );

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
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Fetch Credit Accounts
  static Future<List<Account>> fetchCreditAccounts() async {
    try {
      final response = await http.get(
        Uri.parse(fetchCreditAccountsEndpoint), // Updated endpoint
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch credit accounts: ${data['message']}');
        }
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
        Uri.parse(fetchLoanAccountsEndpoint), // Updated endpoint
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch loan accounts: ${data['message']}');
        }
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
        Uri.parse(fetchFixedAccountsEndpoint), // Updated endpoint
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch fixed accounts: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load fixed accounts');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Fetch Account Details
  static Future<Map<String, dynamic>> fetchAccountDetails(String accountId) async {
    try {
      final response = await http.get(
        Uri.parse(fetchAccountDetailsEndpoint),
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
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Send OTP
  static Future<void> sendOtp(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$sendOtpEndpoint/$userId'), // Updated with userId
        headers: commonHeaders,
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

  // Verify OTP
  static Future<bool> verifyOtp(String userId, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(verifyOtpEndpoint),
        headers: commonHeaders,
        body: jsonEncode({'userId': userId, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('OTP verification failed: ${responseBody['message']}');
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
          'fromAccountId': fromAccountId,
          'toAccountId': toAccountId,
          'amount': amount,
        }),
      );

      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        throw Exception('Transfer funds failed: ${responseBody['message']}');
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
          'accountId': accountId,
          'phoneNumber': phoneNumber,
          'amount': amount,
        }),
      );

      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        throw Exception('Withdraw funds failed: ${responseBody['message']}');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Verify Security Answer
  static Future<void> verifySecurityAnswer(String userId, List<int> list, List<String> list2) async {
    try {
      final response = await http.post(
        Uri.parse(verifySecurityAnswerEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'userId': userId,
          'answers': list,
          'questions': list2,
        }),
      );

      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        throw Exception('Verify security answer failed: ${responseBody['message']}');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Get Security Question
  static Future<Map<String, dynamic>> getSecurityQuestion(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$getSecurityQuestionEndpoint/$userId'),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          return data['entity'];
        } else {
          throw Exception('Failed to get security question: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load security question');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Authenticate Biometric
  static Future<bool> authenticateBiometric(String s) async {
    try {
      final response = await http.post(
        Uri.parse(authenticateBiometricEndpoint),
        headers: commonHeaders,
        body: jsonEncode({'token': s}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('Biometric authentication failed: ${responseBody['message']}');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Authenticate User
  static Future<bool> authenticateUser(String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse(authenticateUserEndpoint),
        headers: commonHeaders,
        body: jsonEncode({'userId': userId, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('User authentication failed: ${responseBody['message']}');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Sign Up User
  static Future<void> signUpUser(int roleId, String userId, String cif) async {
    try {
      final response = await http.post(
        Uri.parse(signUpUserEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'roleId': roleId,
          'userId': userId,
          'cif': cif,
        }),
      );

      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        throw Exception('Sign up user failed: ${responseBody['message']}');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Login
  static Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Login failed');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Sign Up
  static Future<void> signUp(String username, String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse(signupEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Sign up failed');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Password Reset
  static Future<void> resetPassword(String userId, String newPassword, String newPassword, String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse(resetPasswordEndpoint),
        headers: commonHeaders,
        body: jsonEncode({
          'userId': userId,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Password reset failed');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse(logoutEndpoint),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        // Handle successful logout
      } else {
        throw Exception('Logout failed');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  // Fetch Accounts
  static Future<List<Account>> fetchAccounts() async {
    try {
      final response = await http.get(
        Uri.parse(fetchAccountsEndpoint),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['statusCode'] == 200) {
          final List<dynamic> accountsJson = data['entity'];
          return accountsJson.map((json) => Account.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch accounts: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load accounts');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

  static initiateMpesaPrompt(String string, String text, double parse) {}
}

class Account {
  final String accountId;
  final String accountName;
  final double balance;

  var id;

  var type;

  Account({
    required this.accountId,
    required this.accountName,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'],
      accountName: json['accountName'],
      balance: json['balance'],
    );
  }
}

// Define your API response classes
class TransactionResponse {
  final List<Transaction> transactions;

  TransactionResponse({required this.transactions});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> transactionsJson = json['transactions'];
    final List<Transaction> transactions = transactionsJson.map((json) => Transaction.fromJson(json)).toList();
    return TransactionResponse(transactions: transactions);
  }
}

class Transaction {
  final String transactionId;
  final double amount;
  final String description;

  String type;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      amount: json['amount'],
      description: json['description'],
    );
  }
}
