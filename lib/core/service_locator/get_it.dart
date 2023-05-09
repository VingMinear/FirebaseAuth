import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_app/core/service_locator/get_it.config.dart';

final getIt = GetIt.instance;
@InjectableInit()
void configureDependencies() => getIt.init();
