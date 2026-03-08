import 'package:go_router/go_router.dart';

import '../../controllers/session_controller.dart';
import '../../views/screens/auth/login_screen.dart';
import '../../views/screens/auth/register_screen.dart';
import '../../views/screens/favorites/favorites_screen.dart';
import '../../views/screens/home/home_screen.dart';
import '../../views/screens/map/kinshasa_map_screen.dart';
import '../../views/screens/profile/profile_screen.dart';
import '../../views/screens/property/my_properties_screen.dart';
import '../../views/screens/property/property_detail_screen.dart';
import '../../views/screens/property/property_form_screen.dart';
import '../../views/screens/splash_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const propertyDetail = '/property';
  static const newProperty = '/property/new';
  static const myProperties = '/my-properties';
  static const favorites = '/favorites';
  static const map = '/map';
  static const profile = '/profile';
}

GoRouter createRouter(SessionController sessionController) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: sessionController,
    redirect: (context, state) {
      final status = sessionController.status;
      final path = state.matchedLocation;
      final isAuthPage = path == AppRoutes.login || path == AppRoutes.register;

      if (status == SessionStatus.checking) {
        return path == AppRoutes.splash ? null : AppRoutes.splash;
      }
      if (status == SessionStatus.unauthenticated) {
        return isAuthPage ? null : AppRoutes.login;
      }
      if (status == SessionStatus.authenticated) {
        if (isAuthPage || path == AppRoutes.splash) return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.newProperty,
        builder: (context, state) => const PropertyFormScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.propertyDetail}/:id',
        builder: (context, state) =>
            PropertyDetailScreen(propertyId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.myProperties,
        builder: (context, state) => const MyPropertiesScreen(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (context, state) => const KinshasaMapScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
