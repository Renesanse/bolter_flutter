library bolter_flutter;

import 'package:bolter_flutter/src/navigation/navigation_state.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

export 'package:bolter/bolter.dart';
export 'package:hive/hive.dart';
export 'package:hive_flutter/hive_flutter.dart';

export 'src/bolter_provider.dart';
export 'src/navigation/bolter_route.dart';
export 'src/navigation/navigation_mixins.dart';
export 'src/navigation/navigation_state.dart';
export 'src/navigation/navigators.dart';
export 'src/persist/persist.dart';
export 'src/usecase_container.dart';
export 'src/value_stream_builder.dart';

void registerBolterFlutterAdapters() {
  if (!kReleaseMode) {
    print('from 222 to 223 typeId reserved by Bolter Flutter');
  }
  Hive.registerAdapter(NavigationAdapter());
  Hive.registerAdapter(TabNavigationAdapter());
}
