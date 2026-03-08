import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../controllers/auth_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/map_controller.dart';
import '../controllers/property_controller.dart';
import '../controllers/session_controller.dart';

List<SingleChildWidget> createAppProviders({
  required SessionController sessionController,
  required AuthController authController,
  required PropertyController propertyController,
  required FavoritesController favoritesController,
  required MapController mapController,
}) {
  return [
    ChangeNotifierProvider<SessionController>.value(value: sessionController),
    ChangeNotifierProvider<AuthController>.value(value: authController),
    ChangeNotifierProvider<PropertyController>.value(value: propertyController),
    ChangeNotifierProvider<FavoritesController>.value(
      value: favoritesController,
    ),
    ChangeNotifierProvider<MapController>.value(value: mapController),
  ];
}
