import '../core/abstracts/api_client.dart';
import '../core/abstracts/i_admin_service.dart';
import '../services/user_service.dart';
import '../services/admin_service.dart';
import '../services/login_service.dart';
import '../services/communication/dio_client.dart';
import '../services/communication/http_client.dart';
import '../services/auth_service.dart';

class AppContainer {
  late final ApiClient api;
  late final UserService userService;
  late final IAdminService adminService;
  late final AuthService authService;
  late final LoginService loginService;

  AppContainer({bool useDio = true}) {
    authService = AuthService();
    api = useDio ? DioClient(authService: authService) : HttpClientImpl(authService: authService);
    userService = UserService(api);
    adminService = AdminService(api);
    loginService = LoginService(userService, authService);
  }
}
