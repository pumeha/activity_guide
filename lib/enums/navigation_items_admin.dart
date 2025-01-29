import 'package:flutter/material.dart';

enum NavigationItemsAdmin {
  home,
  template_builder,
  dashboard,
  dataset
}

extension NavigationItemsExtensions on NavigationItemsAdmin {
  IconData get icon {
    switch (this) {
      case NavigationItemsAdmin.home:
        return Icons.home;
      case NavigationItemsAdmin.template_builder:
        return Icons.edit_document;
      case NavigationItemsAdmin.dashboard:
        return Icons.dashboard;
      case NavigationItemsAdmin.dataset:
        return Icons.dataset;

      default:
        return Icons.home;
    }
  }
}
