import 'package:flutter/material.dart';
import 'package:passy/common/assets.dart';
import 'package:passy/common/common.dart';
import 'package:passy/passy_data/passy_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    Future(() async {
      data = PassyData((await getApplicationDocumentsDirectory()).path +
          Platform.pathSeparator +
          'Passy');
      loadApp(context);
    });
    return Scaffold(
      body: Center(
        child: purpleLogo,
      ),
    );
  }
}
