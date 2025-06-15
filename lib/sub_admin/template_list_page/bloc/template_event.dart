import 'package:activity_guide/sub_admin/template_list_page/template_model.dart';
import '../../../shared/utils/rowdata_model.dart';

abstract class TemplateEvent {
  
}
class UploadEvent extends TemplateEvent {
  
   List<RowData> rows;
   String? displayName;
   UploadEvent({required this.rows,this.displayName});
}

class UpdateEvent extends TemplateEvent {
  
   List<RowData> rows;
   String? displayName;
   UpdateEvent({required this.rows,this.displayName});
}

class TemplatePurposeEvent extends TemplateEvent {
 final String purpose;
  final String workingTemplate;
  TemplatePurposeEvent({required this.purpose,required this.workingTemplate});
}

class TemplateSelectedEvent extends TemplateEvent {
  
  final TemplateModel model;
  TemplateSelectedEvent({required this.model});
}

class TemplateDeleteEvent extends TemplateEvent {
  final String templateName;
  TemplateDeleteEvent({required this.templateName});
}

class TemplateActiveOrInactiveEvent extends TemplateEvent{
  String templateName;
  String status;
  TemplateActiveOrInactiveEvent({required this.templateName,required this.status});
}

class TemplateFetchDataEvent extends TemplateEvent {
  String templateName;
  TemplateFetchDataEvent({required this.templateName});
}