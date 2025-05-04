import 'package:activity_guide/sub_admin/template_list_page/template_model.dart';
abstract class TemplateState {
 
}

class TemplateInitialState extends TemplateState {
  TemplateInitialState() : super();
}

class TemplateLoadingState extends TemplateState {
    TemplateLoadingState() :super();
}

class TemplateSuccessState extends TemplateState {
  final String message;
  TemplateSuccessState({required this.message});
}

class TemplateFailureState extends TemplateState {
    final String message;
  TemplateFailureState({required this.message}) :super();
}

class TemplateSelectedState extends TemplateState {
  final TemplateModel model;
  TemplateSelectedState({required this.model}) : super();
}