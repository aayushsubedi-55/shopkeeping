import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';
import 'package:shopnepal/core/utils/toast_message_utils.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/product/domain/entities/product.dart';
import 'package:shopnepal/features/product/presentation/cubit/product_form_cubit.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';
import 'package:shopnepal/features/supplier/domain/repositories/supplier_repository.dart';

/// Create/edit form shown as a bottom sheet, same shape as
/// `SupplierFormSheet`. `supplierRepository` is passed in rather than read
/// from context so this sheet (built outside the page's widget tree via
/// `showModalBottomSheet`) doesn't need its own `RepositoryProvider` lookup
/// at build time.
class ProductFormSheet extends StatefulWidget {
  const ProductFormSheet({
    super.key,
    required this.supplierRepository,
    this.product,
  });

  final SupplierRepository supplierRepository;

  /// Null for create, non-null for edit.
  final Product? product;

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _articleNoController;
  late final TextEditingController _nameCnController;
  late final TextEditingController _nameEnController;

  List<Supplier> _suppliers = const [];
  bool _loadingSuppliers = true;
  String? _selectedSupplierId;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _articleNoController = TextEditingController(
      text: widget.product?.articleNo,
    );
    _nameCnController = TextEditingController(text: widget.product?.nameCn);
    _nameEnController = TextEditingController(text: widget.product?.nameEn);
    _selectedSupplierId = widget.product?.supplierId;
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    final res = await widget.supplierRepository.getAll();
    if (!mounted) return;
    setState(() {
      _suppliers = res.data ?? const [];
      _loadingSuppliers = false;
    });
  }

  @override
  void dispose() {
    _articleNoController.dispose();
    _nameCnController.dispose();
    _nameEnController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final supplierId = _selectedSupplierId;
    if (supplierId == null) {
      ToastMessageUtils.error('Please select a supplier');
      return;
    }

    FocusScope.of(context).unfocus();
    final articleNo = _articleNoController.text.trim();
    final nameCn = _nameCnController.text.trim();
    final nameEn = _nameEnController.text.trim();

    final cubit = context.read<ProductFormCubit>();
    if (_isEditing) {
      cubit.update(
        widget.product!.id,
        articleNo: articleNo,
        nameCn: nameCn.isEmpty ? null : nameCn,
        nameEn: nameEn.isEmpty ? null : nameEn,
        supplierId: supplierId,
      );
    } else {
      cubit.create(
        articleNo: articleNo,
        nameCn: nameCn.isEmpty ? null : nameCn,
        nameEn: nameEn.isEmpty ? null : nameEn,
        supplierId: supplierId,
      );
    }
  }

  void _delete(BuildContext context) {
    final product = widget.product;
    if (product == null) return;
    context.read<ProductFormCubit>().delete(product.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductFormCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonSuccess || state is CommonStateSuccess) {
          ToastMessageUtils.show(
            _isEditing ? 'Product saved' : 'Product added',
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
                  _isEditing ? 'Edit product' : 'Add product',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ThemeColors.black,
                  ),
                ),
                const SizedBox(height: AppSpacing.s20),
                _FieldLabel('Article no.'),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: _articleNoController,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: 'Article no.'),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please enter an article number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                _FieldLabel('Supplier'),
                const SizedBox(height: AppSpacing.s8),
                _loadingSuppliers
                    ? const LinearProgressIndicator()
                    : DropdownButtonFormField<String>(
                        initialValue: _selectedSupplierId,
                        decoration: const InputDecoration(
                          hintText: 'Select a supplier',
                        ),
                        items: [
                          for (final supplier in _suppliers)
                            DropdownMenuItem(
                              value: supplier.id,
                              child: Text(supplier.name),
                            ),
                        ],
                        onChanged: isLoading
                            ? null
                            : (value) =>
                                  setState(() => _selectedSupplierId = value),
                      ),
                const SizedBox(height: AppSpacing.s16),
                _FieldLabel('Chinese name (optional)'),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: _nameCnController,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: 'Chinese name'),
                ),
                const SizedBox(height: AppSpacing.s16),
                _FieldLabel('English name (optional)'),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: _nameEnController,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(hintText: 'English name'),
                  onFieldSubmitted: (_) => _submit(context),
                ),
                const SizedBox(height: AppSpacing.s24),
                PrimaryButton(
                  text: _isEditing ? 'Save changes' : 'Add product',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : () => _submit(context),
                ),
                if (_isEditing) ...[
                  const SizedBox(height: AppSpacing.s8),
                  TextButton.icon(
                    onPressed: isLoading ? null : () => _delete(context),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: ThemeColors.red,
                    ),
                    label: const Text(
                      'Delete product',
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
