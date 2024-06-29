import 'dart:convert';
import 'package:http/http.dart' as http;

/// Configurations for API URLs and responses
class Config {
  // Base URLs for different services
  static const String baseUrl = 'https://yourapi.com/api'; // Replace with your actual API base URL
  static const String accountServiceBaseUrl = '$baseUrl/account_service';
  static const String authServiceBaseUrl = '$baseUrl/auth_service';
  static const String mpesaServiceBaseUrl = '$baseUrl/mpesa_service';
  static const String bioServiceBaseUrl = '$baseUrl/bio_service';
  static const String otpServiceBaseUrl = '$baseUrl/otp_service';

  // Endpoints for different services
  static const String getAccountCategoriesEndpoint = '$accountServiceBaseUrl/account_categories';
  static const String resetPasswordEndpoint = '$authServiceBaseUrl/reset_password';
  static const String someOtherServiceEndpoint = '$baseUrl/some_other_service';
  static const String initiateMpesaPromptEndpoint = '$mpesaServiceBaseUrl/initiate';
  static const String biometricAuthEndpoint = '$bioServiceBaseUrl/authenticate';
  static const String sendOtpEndpoint = '$otpServiceBaseUrl/send';
  static const String verifyOtpEndpoint = '$otpServiceBaseUrl/verify';
  static const String transferFundsEndpoint = '$accountServiceBaseUrl/transfer_funds';
  static const String withdrawFundsEndpoint = '$accountServiceBaseUrl/withdraw_funds';
  static const String fetchAccountsEndpoint = '$accountServiceBaseUrl/fetch_accounts';
  static const String fetchCreditAccountsEndpoint = '$accountServiceBaseUrl/credit_accounts';  // New endpoint
  static const String fetchLoanAccountsEndpoint = '$accountServiceBaseUrl/loan_accounts';      // New endpoint
  static const String fetchFixedAccountsEndpoint = '$accountServiceBaseUrl/fixed_accounts';    // New endpoint
  static const String transactionsEndpoint = '$accountServiceBaseUrl/transactions'; // Endpoint for fetching transactions

  // Common HTTP headers
  static Map<String, String> commonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    // Add other common headers here if needed
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

  // Fetch Accounts
  static Future<List<Account>> fetchAccounts() async {
    try {
      final response = await http.get(
        Uri.parse(fetchAccountsEndpoint),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Account> accounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return accounts;
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
        Uri.parse(fetchCreditAccountsEndpoint),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Account> creditAccounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return creditAccounts;
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
        Uri.parse(fetchLoanAccountsEndpoint),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Account> loanAccounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return loanAccounts;
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
        Uri.parse(fetchFixedAccountsEndpoint),
        headers: commonHeaders,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Account> fixedAccounts = body.map((dynamic item) => Account.fromJson(item)).toList();
        return fixedAccounts;
      } else {
        throw Exception('Failed to load fixed accounts');
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

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
      }
    } catch (e) {
      handleApiError(e);
      rethrow;
    }
  }

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

  Transaction({required this.type, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'] as String,
      amount: json['amount'] as String,
    );
  }
}

// Define Account Model
class Account {
  final int id;
  final String name;

  Account({required this.id, required this.name});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
    );
  }
}
