class AppLocalizations {
  static const Map<String, Map<String, String>> translations = {
    'fr': {
      'catalogue': 'Catalogue',
      'details': 'Détails',
      'no_description': 'Pas de description',
      'no_title': 'Sans titre',
      'loading_error': 'Erreur de chargement',
      'error': 'Erreur',
    },
    'en': {
      'catalogue': 'Catalog',
      'details': 'Details',
      'no_description': 'No description',
      'no_title': 'No title',
      'loading_error': 'Loading error',
      'error': 'Error',
    },
  };

  static String translate(String key, String language) {
    return translations[language]?[key] ?? key;
  }
}
