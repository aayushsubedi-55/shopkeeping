import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/presentation/cubit/import_order_cubit.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class ImportOrderFormSheet extends StatefulWidget {
  final bool isEditing;
  final ImportOrder? initialOrder;

  const ImportOrderFormSheet({
    super.key,
    required this.isEditing,
    this.initialOrder,
  });

  @override
  State<ImportOrderFormSheet> createState() => _ImportOrderFormSheetState();
}

class _ImportOrderFormSheetState extends State<ImportOrderFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _freightController = TextEditingController();
  final _customsController = TextEditingController();
  final _otherController = TextEditingController();
  final _fxRateController = TextEditingController();
  DateTime? _selectedDate;
  String _status = 'draft';

  @override
  void initState() {
    super.initState();
    if (widget.initialOrder != null) {
      final order = widget.initialOrder!;
      _freightController.text = order.freightNpr;
      _customsController.text = order.customsNpr;
      _otherController.text = order.otherNpr;
      _fxRateController.text = order.fxRateToNpr ?? '';
      _selectedDate = order.orderDate;
      _status = order.status;
    } else {
      _freightController.text = '0';
      _customsController.text = '0';
      _otherController.text = '0';
    }
  }

  @override
  void dispose() {
    _freightController.dispose();
    _customsController.dispose();
    _otherController.dispose();
    _fxRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImportOrderFormCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonStateSuccess<ImportOrder>) {
          Navigator.pop(context);
          context.read<ImportOrderListCubit>().refresh();
        } else if (state is CommonError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CommonLoading;

        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.s16,
            right: AppSpacing.s16,
            top: AppSpacing.s16,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEditing ? AppStrings.editOrder : AppStrings.createOrder,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: AppStrings.status,
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'draft', child: Text(AppStrings.draft)),
                      DropdownMenuItem(value: 'ordered', child: Text(AppStrings.ordered)),
                      DropdownMenuItem(value: 'received', child: Text(AppStrings.received)),
                      DropdownMenuItem(value: 'cancelled', child: Text(AppStrings.cancelled)),
                    ],
                    onChanged: (value) => setState(() => _status = value ?? 'draft'),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    controller: _fxRateController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.fxRateToNpr,
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 1.85',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final parsed = double.tryParse(value);
                        if (parsed == null || parsed <= 0) {
                          return AppStrings.invalidNumber;
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : '',
                    ),
                    decoration: const InputDecoration(
                      labelText: AppStrings.orderDate,
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    controller: _freightController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.freightNpr,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => _validateAmount(value),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    controller: _customsController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.customsNpr,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => _validateAmount(value),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    controller: _otherController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.otherNpr,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => _validateAmount(value),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  PrimaryButton(
                    text: isLoading ? AppStrings.saving : (widget.isEditing ? AppStrings.update : AppStrings.createOrder),
                    onPressed: isLoading ? null : _submit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = double.tryParse(value);
    if (parsed == null || parsed < 0) {
      return AppStrings.invalidAmount;
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final input = ImportOrderCreateInput(
      status: _status,
      orderDate: _selectedDate,
      fxRateToNpr: _fxRateController.text.isEmpty ? null : _fxRateController.text,
      freightNpr: _freightController.text,
      customsNpr: _customsController.text,
      otherNpr: _otherController.text,
    );

    if (widget.isEditing && widget.initialOrder != null) {
      context.read<ImportOrderFormCubit>().updateOrder(widget.initialOrder!.id, input);
    } else {
      context.read<ImportOrderFormCubit>().createOrder(input);
    }
  }
}