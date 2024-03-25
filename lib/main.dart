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
      builder: (context, child) {
        final scale = MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.6,
              maxScaleFactor: 0.8,
            );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child!,
        );
      },
    );
  }
}
