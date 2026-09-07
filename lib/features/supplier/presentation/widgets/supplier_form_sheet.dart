import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';
import 'package:shopnepal/core/utils/toast_message_utils.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';
import 'package:shopnepal/features/supplier/presentation/cubit/supplier_form_cubit.dart';

/// Create/edit form shown as a bottom sheet, the same shape as
/// `LoginSheet` — a plain widget rather than its own route, opened from
/// `SupplierPage`. Pop the sheet with `true` on a successful save/delete so
/// the caller knows to refresh the list.
class SupplierFormSheet extends StatefulWidget {
  const SupplierFormSheet({super.key, this.supplier});

  /// Null for create, non-null for edit.
  final Supplier? supplier;

  @override
  State<SupplierFormSheet> createState() => _SupplierFormSheetState();
}

class _SupplierFormSheetState extends State<SupplierFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _wechatIdController;

  bool get _isEditing => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name);
    _wechatIdController = TextEditingController(
      text: widget.supplier?.wechatId,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wechatIdController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    final wechatId = _wechatIdController.text.trim();

    final cubit = context.read<SupplierFormCubit>();
    if (_isEditing) {
      cubit.update(
        widget.supplier!.id,
        name: name,
        wechatId: wechatId.isEmpty ? null : wechatId,
      );
    } else {
      cubit.create(name: name, wechatId: wechatId.isEmpty ? null : wechatId);
    }
  }

  void _delete(BuildContext context) {
    final supplier = widget.supplier;
    if (supplier == null) return;
    context.read<SupplierFormCubit>().delete(supplier.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupplierFormCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonSuccess || state is CommonStateSuccess) {
          ToastMessageUtils.show(
            _isEditing ? 'Supplier saved' : 'Supplier added',
          );
          Navigator.of(context).pop(true);
        } else if (state is CommonError) {
          ToastMessageUtils.error(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is CommonLoading;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s20,
            AppSpacing.s20,
            AppSpacing.s20,
            MediaQuery.viewInsetsOf(context).bottom + AppSpacing.s20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? 'Edit supplier' : 'Add supplier',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.black,
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                _FieldLabel('Name'),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: _nameController,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Supplier name',
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please enter a supplier name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                _FieldLabel('WeChat ID (optional)'),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: _wechatIdController,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(hintText: 'WeChat ID'),
                  onFieldSubmitted: (_) => _submit(context),
                ),
                const SizedBox(height: AppSpacing.s24),
                PrimaryButton(
                  text: _isEditing ? 'Save changes' : 'Add supplier',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : () => _submit(context),
                ),
                if (_isEditing) ...[
                  const SizedBox(height: AppSpacing.s8),
                  TextButton.icon(
                    onPressed: isLoading ? null : () => _delete(context),
                    icon: const Icon(Icons.delete_outline, color: ThemeColors.red),
                    label: const Text(
                      'Delete supplier',
                      style: TextStyle(color: ThemeColors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ThemeColors.black,
      ),
    );
  }
}
