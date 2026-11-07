import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/presentation/cubit/import_order_cubit.dart';
import 'package:shopnepal/features/product/domain/repositories/product_repository.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class ImportOrderLineFormSheet extends StatefulWidget {
  final String orderId;
  final bool isEditing;
  final ImportOrderLine? initialLine;

  const ImportOrderLineFormSheet({
    super.key,
    required this.orderId,
    required this.isEditing,
    this.initialLine,
  });

  @override
  State<ImportOrderLineFormSheet> createState() => _ImportOrderLineFormSheetState();
}

class _ImportOrderLineFormSheetState extends State<ImportOrderLineFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _casesController = TextEditingController();
  final _unitPriceController = TextEditingController();
  String _priceBasis = 'per_case';
  String _currency = 'CNY';
  Map<String, int> _ratio = {};
  String? _selectedProductId;
  List<dynamic> _products = [];
  bool _loadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    if (widget.initialLine != null) {
      final line = widget.initialLine!;
      _casesController.text = line.cases.toString();
      _unitPriceController.text = line.unitPrice;
      _priceBasis = line.priceBasis;
      _currency = line.currency;
      _ratio = Map.from(line.ratio);
      _selectedProductId = line.productId;
    } else {
      _casesController.text = '1';
      _unitPriceController.text = '0';
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _loadingProducts = true);
    try {
      final repo = RepositoryProvider.of<ProductRepository>(context);
      final res = await repo.getAll();
      if (res.status == Status.success && res.data != null) {
        setState(() {
          _products = res.data!;
          _loadingProducts = false;
        });
      } else {
        setState(() => _loadingProducts = false);
      }
    } catch (e) {
      setState(() => _loadingProducts = false);
    }
  }

  @override
  void dispose() {
    _casesController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImportOrderLinesCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonStateSuccess<ImportOrderLine> || state is CommonDataFetchSuccess<ImportOrderLine>) {
          Navigator.pop(context);
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
                    widget.isEditing ? AppStrings.editOrderLine : AppStrings.addOrderLine,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  _loadingProducts
                      ? const Center(child: CommonLoader())
                      : DropdownButtonFormField<String>(
                          initialValue: _selectedProductId,
                          decoration: InputDecoration(
                            labelText: AppStrings.product,
                            border: OutlineInputBorder(),
                          ),
                          items: _products.map((product) {
                            return DropdownMenuItem<String>(
                              value: product.id,
                              child: Text('${product.articleNo} - ${product.nameEn ?? product.nameCn ?? ''}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedProductId = value;
                              // Pre-fill ratio from product's defaultRatio
                              final product = _products.firstWhere((p) => p.id == value);
                              if (product.defaultRatio != null && product.defaultRatio!.isNotEmpty) {
                                _ratio = Map.from(product.defaultRatio!);
                              }
                            });
                          },
                          validator: (value) => value == null ? AppStrings.requiredField : null,
                        ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    controller: _casesController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.cases,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.requiredField;
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed <= 0) return AppStrings.invalidNumber;
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  _buildRatioSection(),
                  const SizedBox(height: AppSpacing.s16),
                  DropdownButtonFormField<String>(
                    initialValue: _priceBasis,
                    decoration: const InputDecoration(
                      labelText: AppStrings.priceBasis,
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'per_case', child: Text(AppStrings.perCase)),
                      DropdownMenuItem(value: 'per_pair', child: Text(AppStrings.perPair)),
                    ],
                    onChanged: (value) => setState(() => _priceBasis = value ?? 'per_case'),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    controller: _unitPriceController,
                    decoration: InputDecoration(
                      labelText: _priceBasis == 'per_case' ? AppStrings.unitPricePerCase : AppStrings.unitPricePerPair,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.requiredField;
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed < 0) return AppStrings.invalidAmount;
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: const InputDecoration(
                      labelText: AppStrings.currency,
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'CNY', child: Text('CNY')),
                      DropdownMenuItem(value: 'NPR', child: Text('NPR')),
                    ],
                    onChanged: (value) => setState(() => _currency = value ?? 'CNY'),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  PrimaryButton(
                    text: isLoading ? AppStrings.saving : (widget.isEditing ? AppStrings.update : AppStrings.add),
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

  Widget _buildRatioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.sizeRatio,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.s8),
        if (_ratio.isEmpty)
          Text(
            AppStrings.noRatioSet,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          )
        else
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: _ratio.entries.map((entry) {
              return Chip(
                label: Text('Size ${entry.key}: ${entry.value}'),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => setState(() => _ratio.remove(entry.key)),
              );
            }).toList(),
          ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: '',
                decoration: const InputDecoration(
                  labelText: AppStrings.size,
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 31',
                ),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) => _addRatioSize(value),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: TextFormField(
                initialValue: '',
                decoration: const InputDecoration(
                  labelText: AppStrings.quantity,
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 2',
                ),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) => _addRatioSize(value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addRatioSize(String sizeStr) {
    final size = int.tryParse(sizeStr);
    if (size == null) return;
    // In a real implementation, you'd have a dialog with two fields
    // For simplicity, we'll use a default qty of 1
    setState(() => _ratio[sizeStr] = 1);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.selectProduct)),
      );
      return;
    }

    final input = ImportOrderLineCreateInput(
      productId: _selectedProductId!,
      cases: int.parse(_casesController.text),
      ratio: _ratio,
      unitPrice: _unitPriceController.text,
      priceBasis: _priceBasis,
      currency: _currency,
    );

    if (widget.isEditing && widget.initialLine != null) {
      context.read<ImportOrderLinesCubit>().updateLine(widget.initialLine!.id, input);
    } else {
      context.read<ImportOrderLinesCubit>().addLine(input);
    }
  }
}