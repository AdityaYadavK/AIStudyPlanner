import 'package:go_router/go_router.dart';
import '../screens/auth.dart';
import '../screens/calendar.dart';
import '../screens/dashboard.dart';
import '../screens/generator.dart';
import '../screens/subjects.dart';
import '../screens/tasks.dart';

final GoRouter appRouter = GoRouter(
	initialLocation : '/',
	routes: [
		GoRoute(
			path: '/',
			builder: (context, state) => const AuthScreen(),
		),
		GoRoute(
			path: '/dashboard',
			builder: (context, state) => const DashboardScreen(),
		),
		GoRoute(
			path: '/subjects',
			builder: (context, state) => const SubjectManagerScreen(),
		),
		GoRoute(
			path: '/tasks',
			builder: (context, state) => const TaskInputScreen(),
		),
		GoRoute(
			path: '/generator',
			builder: (context, state) => const AIGeneratorScreen(),
		),
		GoRoute(
			path: '/calendar',
			builder: (context, state) => const CalendarScreen(),
		),
	]
);
