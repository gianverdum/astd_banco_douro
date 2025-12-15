import '../models/account.dart';

double calculateTaxesByAccount({
  required Account sender,
  required double amount,
}) {
  if (amount > 5000) {
    if (sender.accountType != null) {
      switch (sender.accountType!.toUpperCase()) {
        case "AMBROSIA":
          {
            return amount * 0.005;
          }
        case "CANJICA":
          {
            return amount * 0.0033;
          }
        case "PUDIM":
          {
            return amount * 0.0025;
          }
        case "BRIGADEIRO":
          {
            return amount * 0.0001;
          }
        default:
          return amount * 0.01;
      }
    } else {
      return amount * 0.1;
    }
  }
  return 0;
}
