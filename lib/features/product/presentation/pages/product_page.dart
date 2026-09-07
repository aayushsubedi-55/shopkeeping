import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/core/widgets/page_wrapper.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/product/domain/entities/product.dart';
import 'package:shopnepal/features/product/domain/repositories/product_repository.dart';
import 'package:shopnepal/features/product/presentation/cubit/product_form_cubit.dart';
import 'package:shopnepal/features/product/presentation/cubit/product_list_cubit.dart';
import 'package:shopnepal/features/product/presentation/widgets/product_form_sheet.dart';
import 'package:shopnepal/features/product/presentation/widgets/product_tile.dart';
import 'package:shopnepal/features/supplier/domain/repositories/supplier_repository.dart';

/// Products list, reached from the Catalog tab. Create/edit happens in a
/// bottom sheet (`ProductFormSheet`), the same shape `SupplierScreen` uses.
@RoutePage()
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductListCubit(
        productRepository: RepositoryProvider.of<ProductRepository>(context),
      )..fetchAll(),
      child: const _ProductView(),
    );
  }
}

class _ProductView extends StatelessWidget {
  const _ProductView();

  Future<void> _openForm(BuildContext context, {Product? product}) async {
    final productRepository = RepositoryProvider.of<ProductRepository>(
      context,
    );
    final supplierRepository = RepositoryProvider.of<SupplierRepository>(
      context,
    );
    final listCubit = context.read<ProductListCubit>();

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.s20),
        ),
      ),
      builder: (sheetContext) => BlocProvider(
        create: (_) => ProductFormCubit(productRepository: productRepository),
        child: ProductFormSheet(
          supplierRepository: supplierRepository,
          product: product,
        ),
      ),
    );

    if (saved == true) listCubit.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Products',
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductListCubit>().fetchAll(),
        child: BlocBuilder<ProductListCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading || state is CommonInitial) {
              return const Center(child: CommonLoader());
            }

            if (state is CommonError) {
              return _ScrollableMessage(text: state.message);
            }

            if (state is CommonDataFetchSuccess<Product>) {
              final products = state.data;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductTile(
                    product: product,
                    onTap: () => _openForm(context, product: product),
                  );
                },
              );
            }

            return const _ScrollableMessage(
              text: 'No products yet. Add one to get started.',
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppInsets.all16,
          child: PrimaryButton(
            text: 'Add product',
            prefixIcon: Icons.add,
            onPressed: () => _openForm(context),
          ),
        ),
      ),
    );
  }
}

/// Wraps the empty/error text in a scrollable, always-scrollable viewport so
/// pull-to-refresh keeps working even when there is nothing to list.
class _ScrollableMessage extends StatelessWidget {
  const _ScrollableMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s32),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ThemeColors.midGrayColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
