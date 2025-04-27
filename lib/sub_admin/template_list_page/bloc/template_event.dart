import 'package:activity_guide/sub_admin/template_list_page/template_model.dart';
import '../../../shared/utils/rowdata_model.dart';

abstract class TemplateEvent {
  
}
class UploadEvent extends TemplateEvent {
  
   List<RowData> rows;
   UploadEvent({required this.rows});
}

class UpdateEvent extends TemplateEvent {
  
   List<RowData> rows;
   UpdateEvent({required this.rows});
}

class TemplatePurposeEvent extends TemplateEvent {
 final String purpose;

  TemplatePurposeEvent({required this.purpose});
}

class TemplateSelectedEvent extends TemplateEvent {
  
  final TemplateModel model;
  TemplateSelectedEvent({required this.model});
}

class TemplateDeleteEvent extends TemplateEvent {
  final String templateName;
  TemplateDeleteEvent({required this.templateName});
}