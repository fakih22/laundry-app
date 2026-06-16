import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Import core theme and router
import 'core/theme/theme.dart';
import 'core/router/router.dart';

// Import domain interfaces
import 'domain/services/auth_service.dart';
import 'domain/services/order_service.dart';

// Import mock data services
import 'data/services/mock_auth_service.dart';
import 'data/services/mock_order_service.dart';

// Import state managers
import 'presentation/state/auth_state.dart';
import 'presentation/state/cart_state.dart';
import 'presentation/state/order_state.dart';
import 'presentation/state/theme_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Instantiate services
  final authService = MockAuthService();
  final orderService = MockOrderService();

  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider<AuthService>.value(value: authService),
        Provider<OrderService>.value(value: orderService),
        
        // State Managers
        ChangeNotifierProvider<ThemeState>(create: (_) => ThemeState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState(authService)),
        ChangeNotifierProvider<CartState>(create: (_) => CartState()),
        ChangeNotifierProxyProvider<OrderService, OrderState>(
          create: (context) => OrderState(orderService),
          update: (context, svc, previous) => previous ?? OrderState(svc),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);

    return MaterialApp.router(
      title: 'LaundryKu',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme,
      // Implement dark theme support dynamically
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF90CAF9),
          secondary: const Color(0xFFB0BEC5),
        ),
      ),
      themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Indonesian Date picker localization delegates
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      locale: const Locale('id', 'ID'),
    );
  }
}
