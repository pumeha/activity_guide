import 'package:flutter/material.dart';

enum NavigationItemsAdmin {
  template_builder,
  dashboard,
  database,
  users
}

extension NavigationItemsExtensions on NavigationItemsAdmin {
  IconData get icon {
    switch (this) {
      case NavigationItemsAdmin.template_builder:
        return Icons.edit_document;
      case NavigationItemsAdmin.dashboard:
        return Icons.dashboard;
      case NavigationItemsAdmin.database:
        return Icons.dataset;
      case NavigationItemsAdmin.users:
        return Icons.supervised_user_circle_outlined;

      default:
        return Icons.edit_document;
    }
  }
}
