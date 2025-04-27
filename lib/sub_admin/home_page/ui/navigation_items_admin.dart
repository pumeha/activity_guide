import 'package:flutter/material.dart';

enum NavigationItemsAdmin {
  templates,
  dashboard,
  database
}

extension NavigationItemsExtensions on NavigationItemsAdmin {
  IconData get icon {
    switch (this) {
      case NavigationItemsAdmin.templates:
        return Icons.edit_document;
      case NavigationItemsAdmin.dashboard:
        return Icons.dashboard;
      case NavigationItemsAdmin.database:
        return Icons.dataset;

      default:
        return Icons.edit_document;
    }
  }
}
