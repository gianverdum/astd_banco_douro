import 'dart:async';

import '../services/api_key.dart';
import '../models/account.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  String url = "https://api.github.com/gists/1180b5beab545d133091b73519770b01";

  Future<List<Account>> getAll() async {
    Response response = await get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $githubApiKey"},
    );
    _streamController.add("${DateTime.now()} | Requisição de leitura.");

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic = json.decode(
      mapResponse["files"]["accounts.json"]["content"],
    );

    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccounts.add(account);
    }

    return listAccounts;
  }

  Future<void> addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);
    save(listAccounts, accountName: account.name);
  }

  Future<void> save(
    List<Account> listAccounts, {
    String accountName = "",
  }) async {
    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $githubApiKey"},
      body: json.encode({
        "description": "account.json",
        "public": true,
        "files": {
          "accounts.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
        "${DateTime.now()} | Requisição adição bem sucedida ($accountName).",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} | Requisição falhou ($accountName).",
      );
    }
  }
}
