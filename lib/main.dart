import 'package:roomrounds/core/constants/imports.dart';
import 'package:roomrounds/core/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeDark().theme,
      initialRoute: AppRoutes.SPLASH_SCREEN,
      getPages: AppPages.routes,
    );
  }
}
