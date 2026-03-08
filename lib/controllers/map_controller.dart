import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/constants/kinshasa_bounds.dart';

class MapController extends ChangeNotifier {
  LatLng? _selectedPosition;
  String? _errorMessage;

  LatLng? get selectedPosition => _selectedPosition;
  String? get errorMessage => _errorMessage;

  bool isInsideKinshasa(LatLng position) {
    return KinshasaBounds.contains(position);
  }

  bool selectPosition(LatLng position) {
    if (!isInsideKinshasa(position)) {
      _errorMessage =
          'Position invalide: veuillez selectionner un emplacement a Kinshasa.';
      notifyListeners();
      return false;
    }
    _selectedPosition = position;
    _errorMessage = null;
    notifyListeners();
    return true;
  }
}
