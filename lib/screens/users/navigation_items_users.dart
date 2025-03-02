import 'package:flutter/material.dart';

enum NavigationItemsUsers {

  template,
  dashboard,
  database
}

extension NavigationItemsExtensions on NavigationItemsUsers {
  IconData get icon {
    switch (this) {
      case NavigationItemsUsers.template:
        return Icons.edit_document;
      case NavigationItemsUsers.dashboard:
        return Icons.dashboard;
      case NavigationItemsUsers.database:
        return Icons.dataset;

      default:
        return Icons.home;
    }
  }
}
