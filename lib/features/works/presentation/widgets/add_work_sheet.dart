import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/work.dart';
import '../cubit/work_cubit.dart';

class AddWorkSheet extends StatefulWidget {
  const AddWorkSheet({super.key});

  @override
  State<AddWorkSheet> createState() => _AddWorkSheetState();
}

class _AddWorkSheetState extends State<AddWorkSheet> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<ShadFormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      final newWork = Work(
        id: const Uuid().v4(),
        title: title,
        price: price,
        isPaid: false,
        createdAt: DateTime.now(),
      );

      context.read<WorkCubit>().addWork(newWork);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
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
      child: ShadForm(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'works.add_new'.tr(),
              style: theme.textTheme.h3,
            ),
            const SizedBox(height: 24),
            ShadInputFormField(
              controller: _titleController,
              label: Text('works.title'.tr()),
              placeholder: const Text('...'),
              validator: (v) {
                if (v.isEmpty) {
                  return 'works.required'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              controller: _priceController,
              label: Text('works.price'.tr()),
              placeholder: const Text('0.00'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v.isEmpty) {
                  return 'works.required'.tr();
                }
                if (double.tryParse(v) == null) {
                  return 'Invalid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('works.cancel'.tr()),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: _submit,
                  child: Text('works.add_btn'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
