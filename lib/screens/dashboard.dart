
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dashboard.dart';


const _ink = Color(0xFFF5F0FF);
const _muted = Color(0xFFAAA0C5);
const _purple = Color(0xFFB45CFF);
const _page = Color(0xFF090711);


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(userTasksStreamProvider);
    final userAsync = ref.watch(userProfileStreamProvider);

    return Scaffold(
      backgroundColor: _page,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            
colors: [
  Color(0xFF10091F),
  _page,
  Color(0xFF090711),
],

          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    
                    
                    // Header with My Profile
                    Row(
                      children: [
                        // My Profile icon - top left
                        InkWell(
                          onTap: () => context.push('/profile'),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE5DDFB),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _purple.withValues(alpha: 0.12),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Color(0xFF7955F5),
                              size: 28,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // App logo
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_purple, Color(0xFFAA72FF)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Dashboard title
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STUDY SPACE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: _purple,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Dashboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: _ink,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Logout
                       
                      ],
                    ),


                    const SizedBox(height: 27),

                    // Welcome hero
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                         
colors: [
  Color(0xFF190A32),
  Color(0xFF5422A8),
  Color(0xFF9B4DFF),
],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9B4DFF).withValues(alpha: 0.32),
blurRadius: 30,
offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            top: -25,
                            child: Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 18,
                            bottom: 0,
                            child: Icon(
                              Icons.school_rounded,
                              size: 65,
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.13),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: const Text(
                                  '✦  YOUR NEXT CHAPTER STARTS HERE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Dream big.\nStudy smarter.',
                                style: TextStyle(
                                  fontSize: 30,
                                  height: 1.12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Small steps today. Big results tomorrow.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.78),
                                ),
                              ),
                              const SizedBox(height: 21),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.bolt_rounded,
                                    color: Color(0xFFFFD66B),
                                    size: 19,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Make today count',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  FilledButton(
                                    onPressed: () => context.push('/tasks'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF49318F),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 11,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                    ),
                                    child: const Text(
                                      'Plan now  →',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Study goal
                    userAsync.when(
                      data: (snapshot) {
                        final data = snapshot.data();
                        final rawHours = data?['dailyHours'];
                        final double hours = rawHours is num
                            ? rawHours.toDouble()
                            : 0.0;

                        return Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF151020),
                            borderRadius: BorderRadius.circular(23),
                            border: Border.all(
                              color: const Color(0xFF39244F),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _ink.withValues(alpha: 0.035),
                                blurRadius: 18,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 66,
                                height: 66,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const SizedBox.expand(
                                      child: CircularProgressIndicator(
                                        value: 1,
                                        strokeWidth: 6,
                                        color: Color(0xFFF0ECFF),
                                      ),
                                    ),
                                    SizedBox.expand(
                                      child: CircularProgressIndicator(
                                        value: hours > 0 ? 0.7 : 0,
                                        strokeWidth: 6,
                                        strokeCap: StrokeCap.round,
                                        color: _purple,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.schedule_rounded,
                                      color: _purple,
                                      size: 25,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'DAILY STUDY GOAL',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                        color: _muted,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${hours.toStringAsFixed(1)} hours / day',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: _ink,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Available study time',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (err, stack) => Text('Profile error: $err'),
                    ),

                    const SizedBox(height: 30),

                    // Quick actions heading
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: _ink,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECE5FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'EXPLORE',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w900,
                              color: _purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Action grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 13,
                      childAspectRatio: 1.12,
                      children: [
                        _actionCard(
                          context,
                          title: 'Subjects',
                          subtitle: 'Your study topics',
                          icon: Icons.menu_book_rounded,
                          color: const Color(0xFF3478F6),
                          background: const Color(0xFFE9F0FF),
                          onTap: () => context.push('/subjects'),
                        ),
                        _actionCard(
                          context,
                          title: 'Add Tasks',
                          subtitle: 'Plan your workload',
                          icon: Icons.task_alt_rounded,
                          color: const Color(0xFF159B65),
                          background: const Color(0xFFE4F8ED),
                          onTap: () => context.push('/tasks'),
                        ),
                        _actionCard(
                          context,
                          title: 'AI Generator',
                          subtitle: 'Smart study ideas',
                          icon: Icons.auto_awesome_rounded,
                          color: const Color(0xFFE0449B),
                          background: const Color(0xFFFFEAF4),
                          onTap: () => context.push('/generator'),
                        ),
                        _actionCard(
                          context,
                          title: 'Calendar',
                          subtitle: 'Track your dates',
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFFD68B0B),
                          background: const Color(0xFFFFF3D9),
                          onTap: () => context.push('/calendar'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 31),

                    // Upcoming deadlines heading
Row(
  children: [
    const Expanded(
      child: Text(
        'Upcoming Deadlines',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
          color: Color(0xFFF5F0FF),
        ),
      ),
    ),
    tasksAsync.when(
      data: (snapshot) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF25143B),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: const Color(0xFF7540B8),
          ),
        ),
        child: Text(
          '${snapshot.docs.length} tasks',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFFCB9FFF),
          ),
        ),
      ),
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF9B5CFF),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    ),
  ],
),
                    const SizedBox(height: 15),

                   tasksAsync.when(
  data: (snapshot) {
    if (snapshot.docs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xFF151020),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF39244F),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9B5CFF).withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF9B5CFF).withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF9B5CFF).withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.event_available_rounded,
                color: Color(0xFFCB9FFF),
                size: 27,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'A fresh start!',
              style: TextStyle(
                color: Color(0xFFF5F0FF),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your next achievement starts with one task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFAAA0C5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

   
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.docs.length,
                          itemBuilder: (context, index) {
                            final doc = snapshot.docs[index];
                            final data = doc.data();
                            final completed = data['isCompleted'] == true;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFEAE5FA),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _ink.withValues(alpha: 0.035),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 5,
                                        color: completed
                                            ? const Color(0xFF20B77A)
                                            : _purple,
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          leading: Container(
                                            padding: const EdgeInsets.all(11),
                                            decoration: BoxDecoration(
                                              color: completed
                                                  ? const Color(0xFFE5F8EF)
                                                  : const Color(0xFFF0EBFF),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Icon(
                                              completed
                                                  ? Icons.check_circle_rounded
                                                  : Icons.menu_book_rounded,
                                              color: completed
                                                  ? const Color(0xFF20A56E)
                                                  : _purple,
                                            ),
                                          ),
                                          title: Text(
                                            data['title'] ?? 'Untitled',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: _ink,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              '${data['estimatedMinutes'] ?? 0} mins study time',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: _muted,
                                              ),
                                            ),
                                          ),
                                          trailing: IconButton(
                                            tooltip: 'Delete task',
                                            onPressed: () async {
                                              final confirm =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (dialogContext) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                    'Delete task?',
                                                  ),
                                                  content: Text(
                                                    'Delete "${data['title'] ?? 'Untitled'}"?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        dialogContext,
                                                        false,
                                                      ),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                        dialogContext,
                                                        true,
                                                      ),
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirm != true) return;

                                              try {
                                                await doc.reference.delete();
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Task deleted!',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Delete failed: $e',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.more_horiz_rounded,
                                              color: _muted,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(25),
                        child: Center(
                          child: CircularProgressIndicator(color: _purple),
                        ),
                      ),
                      error: (err, stack) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Could not load tasks: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Replace your existing _actionCard helper with this version.
// Keep the same function name and parameters used by your dashboard.

Widget _actionCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required Color color,
  required Color background,
  required VoidCallback onTap,
}) {
  // Keep this helper compatible with the existing call sites.
  // The supplied color/background are intentionally overridden to ensure
  // readable text and consistent neon styling.
  const cardColor = Color(0xFF151020);
  const borderColor = Color(0xFF39244F);
  const titleColor = Color(0xFFF5F0FF);
  const subtitleColor = Color(0xFFAAA0C5);
  final accent = title == 'Subjects'
      ? const Color(0xFF00F5FF)
      : title == 'Add Tasks'
          ? const Color(0xFF67F5B5)
          : title == 'AI Generator'
              ? const Color(0xFFFF6BD6)
              : const Color(0xFFFFC857);

  return Material(
    color: cardColor,
    borderRadius: BorderRadius.circular(23),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(23),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.09),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.38),
                    ),
                  ),
                  child: Icon(icon, color: accent, size: 24),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 18,
                  color: accent,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: subtitleColor,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}