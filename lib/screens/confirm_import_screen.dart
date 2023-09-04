import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kdbx/kdbx.dart';
import 'package:passy/common/common.dart';
import 'package:passy/passy_data/loaded_account.dart';
import 'package:passy/passy_flutter/passy_flutter.dart';
import 'package:passy/screens/common.dart';
import 'package:passy/screens/login_screen.dart';
import 'package:passy/screens/main_screen.dart';
import 'package:passy/screens/splash_screen.dart';

import 'import_screen.dart';
import 'log_screen.dart';

enum ImportType {
  passy,
  kdbx,
}

class ConfirmImportScreenArgs {
  final String path;
  final ImportType importType;

  ConfirmImportScreenArgs({
    required this.path,
    required this.importType,
  });
}

class ConfirmImportScreen extends StatefulWidget {
  static const String routeName = '${ImportScreen.routeName}/confirm';

  const ConfirmImportScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfirmImportScreen();
}

class _ConfirmImportScreen extends State<ConfirmImportScreen> {
  final LoadedAccount _account = data.loadedAccount!;

  Future<void> _onConfirmPressed(
      BuildContext context, String value, ConfirmImportScreenArgs args) async {
    Navigator.pushNamed(context, SplashScreen.routeName);
    try {
      switch (args.importType) {
        case ImportType.passy:
          await data.importAccount(args.path,
              encrypter: (await data.getEncrypter(_account.username,
                  password: value))!,
              syncEncrypter: (await data.getSyncEncrypter(
                  username: _account.username, password: value)));
          Navigator.popUntil(
              context, (route) => route.settings.name == MainScreen.routeName);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          break;
        case ImportType.kdbx:
          KdbxFile file = await KdbxFormat().read(
              await File(args.path).readAsBytes(),
              Credentials(ProtectedValue.fromString(value)));
          await _account
              .importKDBXPasswords(file.body.rootGroup.getAllEntries());
          Navigator.popUntil(context,
              (route) => route.settings.name == ImportScreen.routeName);
          break;
      }
    } catch (e, s) {
      Navigator.pop(context);
      showSnackBar(
        context,
        message: localizations.couldNotImportAccount,
        icon: const Icon(Icons.download_for_offline_outlined,
            color: PassyTheme.darkContentColor),
        action: SnackBarAction(
          label: localizations.details,
          onPressed: () => Navigator.pushNamed(context, LogScreen.routeName,
              arguments: e.toString() + '\n' + s.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ConfirmImportScreenArgs args =
        ModalRoute.of(context)!.settings.arguments as ConfirmImportScreenArgs;
    return ConfirmStringScaffold(
        title: Text(args.importType == ImportType.passy
            ? localizations.passyImport
            : localizations.kdbxImport),
        message: PassyPadding(RichText(
          text: TextSpan(
            text: localizations.confirmImport1,
            children: [
              TextSpan(
                text: localizations.confirmImport2Highlighted,
                style: const TextStyle(
                    color: PassyTheme.lightContentSecondaryColor),
              ),
              TextSpan(
                  text:
                      '${localizations.confirmImport3}.\n\n${localizations.enterAccountPasswordToImport}.'),
            ],
          ),
          textAlign: TextAlign.center,
        )),
        labelText: localizations.enterPassword,
        obscureText: true,
        confirmIcon: const Icon(Icons.download_for_offline_outlined),
        onBackPressed: (context) => Navigator.pop(context),
        onConfirmPressed: (context, value) =>
            _onConfirmPressed(context, value, args));
  }
}
