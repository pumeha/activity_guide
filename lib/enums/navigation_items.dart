import 'package:flutter/material.dart';

enum NavigationItems {
  home,
  template,
  dashboard
}

extension NavigationItemsExtensions on NavigationItems {
  IconData get icon {
    switch (this) {
      case NavigationItems.home:
        return Icons.home;
      case NavigationItems.template:
        return Icons.edit_document;
      case NavigationItems.dashboard:
        return Icons.dashboard;

      default:
        return Icons.home;
    }
  }
}
