import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../domain/entities/work.dart';
import '../cubit/work_cubit.dart';
import '../cubit/work_state.dart';
import '../widgets/add_work_sheet.dart';
import '../widgets/edit_work_sheet.dart';
import '../../../settings/presentation/widgets/settings_sheet.dart';
import '../../../sync/presentation/cubit/sync_cubit.dart';

class WorkListPage extends StatefulWidget {
  const WorkListPage({super.key});

  @override
  State<WorkListPage> createState() => _WorkListPageState();
}

class _WorkListPageState extends State<WorkListPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkCubit>().getWorks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr(), style: theme.textTheme.h4),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              final syncCubit = context.read<SyncCubit>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => BlocProvider.value(
                  value: syncCubit,
                  child: const SettingsSheet(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          BlocConsumer<WorkCubit, WorkState>(
        listener: (context, state) {
          if (state is WorkError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.destructive,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WorkLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: theme.colorScheme.destructive),
              ),
            );
          } else if (state is WorkLoaded) {
            final works = state.works;
            
            final totalEarnings = works
                .where((w) => w.isPaid)
                .fold(0.0, (sum, w) => sum + w.price);
                
            final pendingPayments = works
                .where((w) => !w.isPaid)
                .fold(0.0, (sum, w) => sum + w.price);

            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  _buildHeader(context, totalEarnings, pendingPayments),
                  TabBar(
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: theme.colorScheme.mutedForeground,
                    indicatorColor: theme.colorScheme.primary,
                    tabs: [
                      Tab(text: 'works.pending'.tr()),
                      Tab(text: 'works.paid'.tr()),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildList(context, works.where((w) => !w.isPaid).toList()),
                        _buildList(context, works.where((w) => w.isPaid).toList()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ],
  ),
  floatingActionButton: ShadButton(
        child: const Icon(Icons.add, size: 24),
        onPressed: () {
          final cubit = context.read<WorkCubit>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => BlocProvider.value(
              value: cubit,
              child: const AddWorkSheet(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double totalEarnings, double pendingPayments) {
    final theme = ShadTheme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ShadCard(
              title: Text('works.total_earnings'.tr(), style: theme.textTheme.small),
              description: Text(
                '₺${totalEarnings.toStringAsFixed(2)}',
                style: theme.textTheme.h3.copyWith(color: theme.colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ShadCard(
              title: Text('works.pending_payments'.tr(), style: theme.textTheme.small),
              description: Text(
                '₺${pendingPayments.toStringAsFixed(2)}',
                style: theme.textTheme.h3.copyWith(color: theme.colorScheme.destructive),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Work> works) {
    if (works.isEmpty) {
      return Center(child: Text('works.empty'.tr()));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: works.length,
      itemBuilder: (context, index) {
        final work = works[index];
        return _buildWorkItem(context, work)
            .animate()
            .fade(duration: 300.ms, delay: (index * 50).ms)
            .slideY(begin: 0.2, duration: 300.ms, curve: Curves.easeOutQuad);
      },
    );
  }

  Widget _buildWorkItem(BuildContext context, Work work) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(work.id),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.destructive,
            borderRadius: theme.radius,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: Icon(Icons.delete, color: theme.colorScheme.destructiveForeground),
        ),
        confirmDismiss: (direction) async {
          // Delete
          final cubit = context.read<WorkCubit>();
          cubit.deleteWork(work.id);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('works.deleted'.tr()),
              action: SnackBarAction(
                label: 'works.undo'.tr(),
                onPressed: () {
                  cubit.addWork(work); // Re-add the deleted work
                },
              ),
            ),
          );
          return true;
        },
        child: ShadCard(
          child: ListTile(
            onTap: () {
              final cubit = context.read<WorkCubit>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => BlocProvider.value(
                  value: cubit,
                  child: EditWorkSheet(work: work),
                ),
              );
            },
            contentPadding: EdgeInsets.zero,
            title: Text(
              work.title,
              style: theme.textTheme.large.copyWith(
                decoration: work.isPaid ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(work.createdAt),
              style: theme.textTheme.muted,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₺${work.price.toStringAsFixed(2)}',
                      style: theme.textTheme.large,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.read<WorkCubit>().updateWorkStatus(work);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('works.save'.tr()),
                        action: SnackBarAction(
                          label: 'works.undo'.tr(),
                          onPressed: () {
                            context.read<WorkCubit>().updateWorkStatus(work);
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: work.isPaid ? theme.colorScheme.primary : theme.colorScheme.muted,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        work.isPaid ? Icons.check : Icons.hourglass_empty,
                        key: ValueKey(work.isPaid),
                        size: 20,
                        color: work.isPaid ? theme.colorScheme.primaryForeground : theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
