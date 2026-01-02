import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/models/account.dart';
import 'package:flutter_banco_douro/services/account_service.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';
import 'package:uuid/uuid.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _accountTypeController = "AMBROSIA";

  final _nameFocus = FocusNode();
  final _lastNameFocus = FocusNode();

  final _scrollController = ScrollController();

  final _nameFieldKey = GlobalKey();
  final _lastNameFieldKey = GlobalKey();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() {
      if (_nameFocus.hasFocus) _scrollToField(_nameFieldKey);
    });

    _lastNameFocus.addListener(() {
      if (_lastNameFocus.hasFocus) _scrollToField(_lastNameFieldKey);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _scrollController.dispose();

    _nameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  Future<void> _scrollToField(GlobalKey key) async {
    await Future.delayed(const Duration(milliseconds: 80));

    final ctx = key.currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.25, // 0 = topo, 1 = fundo (0.25 costuma ficar bom)
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
            top: 32,
            bottom: bottomInset > 0 ? bottomInset + 16 : 32,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Image.asset(
                      "assets/images/icon_add_account.png",
                      width: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Adicionar nova conta",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Preencha os dados abaixo:",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    key: _nameFieldKey,
                    controller: _nameController,
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.next,
                    scrollPadding: const EdgeInsets.only(bottom: 160),
                    decoration: const InputDecoration(labelText: "Nome"),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Informe o nome"
                        : null,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(_lastNameFocus);
                    },
                  ),

                  TextFormField(
                    key: _lastNameFieldKey,
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    textInputAction: TextInputAction.done,
                    scrollPadding: const EdgeInsets.only(bottom: 160),
                    decoration: const InputDecoration(labelText: "Último nome"),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Informe o último nome"
                        : null,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 24),
                  // const Text(
                  //   "Tipo da conta",
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  // ),
                  // const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _accountTypeController,
                    decoration: const InputDecoration(
                      labelText: "Selecione o tipo de conta",
                      border: UnderlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "AMBROSIA",
                        child: Text("Ambrosia"),
                      ),
                      DropdownMenuItem(
                        value: "CANJICA",
                        child: Text("Canjica"),
                      ),
                      DropdownMenuItem(value: "PUDIM", child: Text("Pudim")),
                      DropdownMenuItem(
                        value: "BRIGADEIRO",
                        child: Text("Brigadeiro"),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _accountTypeController = value;
                        });
                      }
                    },
                    validator: (value) =>
                        value == null ? "Selecione um tipo" : null,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (isLoading)
                              ? null
                              : () {
                                  onButtonCancelClicked();
                                },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onButtonAddClicked,
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColor.orange,
                            ),
                          ),
                          child: (isLoading)
                              ? CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Adicionar",
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonCancelClicked() {
    if (!isLoading) {
      Navigator.pop(context);
    }
  }

  void onButtonAddClicked() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      String name = _nameController.text.trim();
      String lastName = _lastNameController.text.trim();

      Account account = Account(
        id: const Uuid().v4(),
        name: name,
        lastName: lastName,
        balance: 0,
        accountType: _accountTypeController,
      );

      try {
        await AccountService().addAccount(account);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conta adicionada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao adicionar conta: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
