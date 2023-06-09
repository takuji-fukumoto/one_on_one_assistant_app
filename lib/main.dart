import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/data/repositories/local_store_provider.dart';

import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var box = await ObjectBox.create();

  runApp(
    ProviderScope(
      overrides: [
        storeProvider.overrideWithValue(box.store),
      ],
      child: const App(),
    ),
  );
}
