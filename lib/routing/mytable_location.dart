import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../screens/admin/data_table.dart';
import '../utils/constants.dart';
class DatatableLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child: MyTable(),title: appName,
        key: ValueKey('dataset'))];
  }

  @override
  List<Pattern> get pathPatterns => ['/admin/dataset'];

}