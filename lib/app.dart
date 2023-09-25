import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_cat/app_lifecycle_observer.dart';
import 'package:todo_cat/config/smart_dialog.dart';
import 'package:todo_cat/data/schemas/app_config.dart';
import 'package:todo_cat/data/services/repositorys/app_config.dart';
import 'package:todo_cat/locales/locales.dart';
import 'package:todo_cat/manager/local_notification_manager.dart';
import 'package:todo_cat/pages/unknown.dart';
import 'package:todo_cat/routers/router_map.dart';
import 'package:todo_cat/themes/dark_theme.dart';
import 'package:todo_cat/themes/light_theme.dart';
import 'package:todo_cat/themes/theme_mode.dart';
import 'package:window_manager/window_manager.dart';

class AppController extends GetxController {
  late final LocalNotificationManager localNotificationManager;
  late final AppConfigRepository appConfigRepository;
  late final appConfig = Rx<AppConfig>(
    AppConfig(
      configName: "default",
      isDarkMode: true,
      locale: const Locale("zh", "CN"),
    ),
  );
  final isMaximize = false.obs;
  final isFullScreen = false.obs;

  @override
  void onInit() async {
    localNotificationManager = await LocalNotificationManager.getInstance();
    localNotificationManager.checkAllLocalNotification();
    appConfigRepository = await AppConfigRepository.getInstance();
    final AppConfig? currentAppConfig = appConfigRepository.read(
      appConfig.value.configName,
    );
    if (currentAppConfig != null) {
      appConfig.value = currentAppConfig;
      changeLanguage(appConfig.value.locale);
    } else {
      appConfigRepository.write(appConfig.value.configName, appConfig.value);
    }

    ever(
      appConfig,
      (value) async => {appConfigRepository.update(value.configName, value)},
    );

    super.onInit();
  }

  @override
  void onReady() {
    // 改变移动端顶部状态栏、底部导航栏样式
    changeSystemOverlayUI();
    // 初始化SmartDialogConfiguration
    initSmartDialogConfiguration();
    // 添加生命周期监听事件
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
    super.onReady();
  }

  void changeThemeMode(TodoCatThemeMode mode) {
    appConfig.value.isDarkMode = mode == TodoCatThemeMode.dark ? true : false;
    appConfig.refresh();
  }

  void changeSystemOverlayUI() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await FlutterStatusbarcolor.setStatusBarWhiteForeground(
          appConfig.value.isDarkMode ? true : false);
    }
  }

  void targetThemeMode() {
    appConfig.value.isDarkMode = !appConfig.value.isDarkMode;
    appConfig.refresh();
    if (Platform.isAndroid || Platform.isIOS) {
      changeSystemOverlayUI();
    }
  }

  void changeLanguage(Locale language) async {
    await Get.updateLocale(language);
    appConfig.value.locale = Get.locale!;
    appConfig.refresh();
  }

  @override
  void onClose() {
    localNotificationManager.destroyLocalNotification();
    super.onClose();
  }

  void minimizeWindow() async {
    await windowManager.minimize();
  }

  void updateWindowStatus() async {
    final maximized = await windowManager.isMaximized();
    isMaximize.value = maximized;
    final fullScreen = await windowManager.isFullScreen();
    isFullScreen.value = fullScreen;
  }

  void targetMaximizeWindow() async {
    if (isMaximize.value) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
    updateWindowStatus();
  }

  void closeWindow() async {
    await windowManager.close();
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppController _appController;

  @override
  void initState() {
    Get.put(AppController());
    _appController = Get.find();

    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      // 移除启动页面
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "TodoCat",
            translations: Locales(),
            locale: _appController.appConfig.value.locale,
            fallbackLocale: const Locale('en', 'US'),
            builder: FlutterSmartDialog.init(),
            navigatorObservers: [FlutterSmartDialog.observer],
            themeMode: _appController.appConfig.value.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            useInheritedMediaQuery: true,
            unknownRoute: GetPage(
              name: '/notfound',
              page: () => const UnknownPage(),
              transition: Transition.fadeIn,
            ),
            initialRoute: '/start',
            getPages: routerMap,
          ),
        );
      },
    );
  }
}
