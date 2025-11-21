import 'package:flutter/foundation.dart';

class AssetHelper {
  /// Convertit un chemin d'asset local en chemin approprié pour le web
  static String getAssetPath(String localPath) {
    if (!kIsWeb) {
      return localPath;
    }

    // Sur le web, les assets sont servis depuis la racine
    // et les chemins dans le JSON contiennent déjà 'assets/'
    if (localPath.startsWith('assets/')) {
      return localPath;
    }

    return localPath;
  }

  /// Vérifie si un chemin d'asset est valide
  static bool isValidAssetPath(String path) {
    return path.isNotEmpty &&
        (path.startsWith('assets/') || path.startsWith('http'));
  }
}
