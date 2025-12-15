import '../models/account.dart';

class SenderNotExistsException implements Exception {
  final String message;
  SenderNotExistsException({this.message = "Sender does not exist."});
}

class ReceiverNotExistsException implements Exception {
  final String message;
  ReceiverNotExistsException({this.message = "Receiver does not exist."});
}

class InsufficientFundsException implements Exception {
  String message; // Mensagem amigável
  Account cause; // Objeto causador da exceção
  double amount; // Informações específicas
  double taxes; // Informações específicas

  InsufficientFundsException({
    this.message = "Insufficient funds for the transaction.",
    required this.cause,
    required this.amount,
    required this.taxes,
  });
}
