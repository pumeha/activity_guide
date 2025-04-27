import 'package:activity_guide/authentication/view/authentication.dart';
import 'package:activity_guide/authentication/view/forget_password_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../shared/utils/constants.dart';
import '../view/account_verification_page.dart';
import '../view/new_password_page.dart';

class LoginLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: AuthenticationPage(),key: ValueKey('login'),title: appName)];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/login'];
}

class ForgetPasswordLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: ForgetPasswordPage(),key: ValueKey('reset_password'),title: appName)];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/reset_password'];
}

class AccountVerificationLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: AccountVerificationPage(),key: ValueKey('account_verification'),title: appName)];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/account_verification'];

}
class NewPasswordLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: NewPasswordPage(),key: ValueKey('new_password'),title: appName)];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/new_password'];

}

