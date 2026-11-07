import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/presentation/cubit/stock_cubit.dart';
import 'package:shopnepal/features/product/domain/repositories/product_repository.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class StockMovementSheet extends StatefulWidget {
  final String? initialProductId;
  final int? initialSize;

  const StockMovementSheet({
    super.key,
    this.initialProductId,
    this.initialSize,
  });

  @override
  State<StockMovementSheet> createState() => _StockMovementSheetState();
}

class _StockMovementSheetState extends State<StockMovementSheet> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  String _reason = 'sale';
  String? _selectedProductId;
  int? _selectedSize;
  List<dynamic> _products = [];
  bool _loadingProducts = true;

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.initialProductId;
    _selectedSize = widget.initialSize;
    _loadProducts();
    if (widget.initialSize != null) {
      // For sale/damage, qty is negative
      _qtyController.text = '';
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
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StockMovementCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonStateSuccess<StockMovement>) {
          Navigator.pop(context);
          context.read<StockCubit>().refresh();
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
                    AppStrings.stockMovement,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  _loadingProducts
                      ? const Center(child: CommonLoader())
                      : DropdownButtonFormField<String>(
                          initialValue: _selectedProductId,
                          decoration: const InputDecoration(
                            labelText: AppStrings.product,
                            border: OutlineInputBorder(),
                          ),
                          items: _products.map((product) {
                            return DropdownMenuItem<String>(
                              value: product.id,
                              child: Text('${product.articleNo} - ${product.nameEn ?? product.nameCn ?? ''}'),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _selectedProductId = value),
                          validator: (value) => value == null ? AppStrings.requiredField : null,
                        ),
                  const SizedBox(height: AppSpacing.s16),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedSize,
                    decoration: const InputDecoration(
                      labelText: AppStrings.size,
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(12, (i) => 31 + i)
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size.toString()),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedSize = value),
                    validator: (value) => value == null ? AppStrings.requiredField : null,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  DropdownButtonFormField<String>(
                    initialValue: _reason,
                    decoration: const InputDecoration(
                      labelText: AppStrings.reason,
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'sale', child: Text(AppStrings.sale)),
                      DropdownMenuItem(value: 'adjustment', child: Text(AppStrings.adjustment)),
                      DropdownMenuItem(value: 'damage', child: Text(AppStrings.damage)),
                    ],
                    onChanged: (value) => setState(() => _reason = value ?? 'sale'),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  TextFormField(
                    controller: _qtyController,
                    decoration: InputDecoration(
                      labelText: _reason == 'sale' || _reason == 'damage'
                          ? AppStrings.qtyNegative
                          : AppStrings.qtyPositive,
                      border: const OutlineInputBorder(),
                      hintText: _reason == 'sale' || _reason == 'damage' ? '-5' : '5',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppStrings.requiredField;
                      final parsed = int.tryParse(value);
                      if (parsed == null || parsed == 0) return AppStrings.invalidQty;
                      if ((_reason == 'sale' || _reason == 'damage') && parsed > 0) {
                        return AppStrings.qtyMustBeNegative;
                      }
                      if (_reason == 'adjustment' && parsed < 0) {
                        return AppStrings.qtyMustBePositive;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  PrimaryButton(
                    text: isLoading ? AppStrings.saving : AppStrings.record,
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProductId == null || _selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.selectProductAndSize)),
      );
      return;
    }

    final input = StockMovementInput(
      productId: _selectedProductId!,
      size: _selectedSize!,
      qty: int.parse(_qtyController.text),
      reason: _reason,
    );

    context.read<StockMovementCubit>().createMovement(input);
  }
}