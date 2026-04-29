import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../sync/presentation/cubit/sync_cubit.dart';
import '../../../sync/presentation/cubit/sync_state.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('settings.title'.tr(), style: theme.textTheme.h3),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('settings.theme'.tr(), style: theme.textTheme.large),
          const SizedBox(height: 12),
          BlocBuilder<ThemeCubit, AppSeasonalTheme>(
            builder: (context, currentTheme) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppSeasonalTheme.values.map<Widget>((season) {
                  final isSelected = currentTheme == season;
                  if (isSelected) {
                    return ShadButton(
                      onPressed: () {
                        context.read<ThemeCubit>().changeTheme(season);
                      },
                      child: Text(season.localizationKey.tr()),
                    );
                  } else {
                    return ShadButton.outline(
                      onPressed: () {
                        context.read<ThemeCubit>().changeTheme(season);
                      },
                      child: Text(season.localizationKey.tr()),
                    );
                  }
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 32),
          Text('settings.language'.tr(), style: theme.textTheme.large),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _LanguageButton(locale: Locale('tr'), label: 'Türkçe'),
              _LanguageButton(locale: Locale('en'), label: 'English'),
              _LanguageButton(locale: Locale('de'), label: 'Deutsch'),
              _LanguageButton(locale: Locale('fr'), label: 'Français'),
              _LanguageButton(locale: Locale('es'), label: 'Español'),
              _LanguageButton(locale: Locale('pt'), label: 'Português'),
              _LanguageButton(locale: Locale('it'), label: 'Italiano'),
            ],
          ),
          const SizedBox(height: 32),
          Text('sync.title'.tr(), style: theme.textTheme.large),
          const SizedBox(height: 12),
          BlocConsumer<SyncCubit, SyncState>(
            listener: (context, state) {
              if (state is SyncSuccess) {
                ShadToaster.of(context).show(
                  ShadToast(description: Text(state.message)),
                );
              } else if (state is SyncError) {
                ShadToaster.of(context).show(
                  ShadToast.destructive(description: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<SyncCubit>();
              final isSignedIn = cubit.isSignedIn;
              final isLoading = state is SyncInProgress;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isSignedIn)
                    ShadButton(
                      onPressed: isLoading ? null : () => cubit.signIn(),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('sync.sign_in'.tr()),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: ShadButton(
                            onPressed: isLoading ? null : () => cubit.backup(),
                            child: isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text('sync.backup'.tr()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ShadButton.outline(
                            onPressed: isLoading ? null : () => cubit.restore(),
                            child: isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text('sync.restore'.tr()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ShadButton.ghost(
                      onPressed: isLoading ? null : () => cubit.signOut(),
                      child: Text('sync.sign_out'.tr()),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final Locale locale;
  final String label;

  const _LanguageButton({required this.locale, required this.label});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final isSelected = currentLocale == locale;

    if (isSelected) {
      return ShadButton(
        onPressed: () {
          context.setLocale(locale);
        },
        child: Text(label),
      );
    } else {
      return ShadButton.outline(
        onPressed: () {
          context.setLocale(locale);
        },
        child: Text(label),
      );
    }
  }
}
