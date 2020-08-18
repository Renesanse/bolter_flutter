library bolter_flutter;

import 'package:bolter_flutter/src/navigation_state.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

export 'package:bolter/bolter.dart';
export 'src/bolter_provider.dart';
export 'src/bolter_route.dart';
export 'src/navigation_mixins.dart';
export 'src/navigation_state.dart';
export 'src/navigators.dart';
export 'src/persist.dart';
export 'src/value_stream_builder.dart';
export 'package:hive/hive.dart';
export 'package:hive_flutter/hive_flutter.dart';
export 'src/usecase_container/usecase_container.dart';

void registerBolterFlutterAdapters() {
  if (!kReleaseMode) {
    print('from 222 to 223 typeId reserved by Bolter Flutter');
  }
  Hive.registerAdapter(NavigationAdapter());
  Hive.registerAdapter(TabNavigationAdapter());
}
