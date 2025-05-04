import 'package:flutter/material.dart';

enum NavigationItemsAdmin {
  templates,
  dashboard
}

extension NavigationItemsExtensions on NavigationItemsAdmin {
  IconData get icon {
    switch (this) {
      case NavigationItemsAdmin.templates:
        return Icons.edit_document;
      case NavigationItemsAdmin.dashboard:
        return Icons.dashboard;

      default:
        return Icons.edit_document;
    }
  }
}
