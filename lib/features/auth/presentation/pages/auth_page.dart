import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'auth.welcome'.tr(),
              style: ShadTheme.of(context).textTheme.h1,
            ),
            const SizedBox(height: 24),
            ShadButton(
              onPressed: () {},
              child: Text('auth.login'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
