String baseUrl = "https://www.smarterwaysolutions.site/endpoints";
//String baseUrl = "http://localhost:5000/endpoints";//activityguide.smarterwaysolutions.site

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
static String uploadTemplateData = "$baseUrl/template/upload";
static String fetchData = "$baseUrl/template/fetch";
static String fetchMonthlyTemplateData = "$baseUrl/template/monthly";
static String fetchDashboardData = "$baseUrl/template/dashdata";
}

class UserRoutes {
static String getUsers = "$baseUrl/users";
static String updateUser = "$getUsers/update";
static String asdUser = "$getUsers/asd";
}

class WorkplanRoutes {
static String upload = "$baseUrl/workplans/upload";
static String getAll = "$baseUrl/workplans/getall";
static String bydept = "$baseUrl/workplans/bydept";
static String edit = "$baseUrl/workplans/edit";
static String delete = "$baseUrl/workplans/delete";
}
