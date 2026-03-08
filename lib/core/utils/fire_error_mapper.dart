String mapFirebaseError(Object error) {
  final text = error.toString();
  if (text.contains('user-not-found')) {
    return 'Utilisateur introuvable.';
  }
  if (text.contains('wrong-password')) {
    return 'Mot de passe incorrect.';
  }
  if (text.contains('email-already-in-use')) {
    return 'Cet email est deja utilise.';
  }
  if (text.contains('network-request-failed')) {
    return 'Erreur reseau.';
  }
  return 'Une erreur est survenue.';
}
