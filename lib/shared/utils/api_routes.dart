String baseUrl = "http://localhost:5000/endpoints";
class LoginRoutes {
static String loginRoute = "$baseUrl/auth/login";
static String forgetPassword = "$baseUrl/auth/forgetpassword";
static String requesttoken = "$baseUrl/auth/requesttoken";
static String verify = "$baseUrl/auth/verify";
static String register = "$baseUrl/auth/register";
}

class TemplateRoutes {
static String createTemplate = "$baseUrl/template/create";
static String listTemplateName = "$baseUrl/template";
static String deleteTemplate = "$baseUrl/template/delete";
static String updateTemplate = "$baseUrl/template/update";
static String getTemplateData = "$baseUrl/template/fetch";
static String templateActive = "$baseUrl/template/active";
static String dashboard = "$baseUrl/template/dashboard";
}

class UserRoutes {
static String getUsers = "$baseUrl/users";
static String updateUser = "$getUsers/update";
static String suspendUser = "$getUsers/suspend";
static String deleteUser = "$getUsers/delete";
static String activeUser = "$getUsers/active";
}

class WorkplanRoutes {
static String upload = "$baseUrl/workplans/upload";
static String getAll = "$baseUrl/workplans/getall";
static String bydept = "$baseUrl/workplans/bydept";
static String edit = "$baseUrl/workplans/edit";
static String delete = "$baseUrl/workplans/delete";
}