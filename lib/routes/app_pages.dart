import 'package:get/get.dart';
import '../presentation/views/dashboard_view.dart';
import '../presentation/views/details_view.dart';
import '../presentation/views/settings_view.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => DashboardView()),
    GetPage(name: '/details', page: () => DetailsView()),
    GetPage(name: '/settings', page: () => SettingsView()),
  ];
}
