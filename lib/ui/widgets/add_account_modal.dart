import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _nameFocus = FocusNode();
  final _lastNameFocus = FocusNode();

  final _scrollController = ScrollController();

  final _nameFieldKey = GlobalKey();
  final _lastNameFieldKey = GlobalKey();

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

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final name = _nameController.text.trim();
    final lastName = _lastNameController.text.trim();

    debugPrint('Submit: $name $lastName');

    Navigator.of(context).pop();
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
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: bottomInset),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
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
                    onFieldSubmitted: (_) {
                      _submit();
                    },
                  ),

                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                          onPressed: _submit,
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColor.orange,
                            ),
                          ),
                          child: const Text(
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
}
