class Validators {
  const Validators._();

  static String? requiredField(String? value, {String fieldName = 'Champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire.';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email obligatoire.';
    }
    final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Email invalide.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Mot de passe minimum 6 caracteres.';
    }
    return null;
  }
}
