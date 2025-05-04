import 'package:flutter/material.dart';

enum NavigationItemsUsers {
  home,
  dashboard
}

extension NavigationItemsExtensions on NavigationItemsUsers {
  IconData get icon {
    switch (this) {
      case NavigationItemsUsers.home:
        return Icons.home;
      case NavigationItemsUsers.dashboard:
        return Icons.dashboard;

      default:
        return Icons.edit_document;
    }
  }
}
