import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/core/widgets/page_wrapper.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';
import 'package:shopnepal/features/supplier/domain/repositories/supplier_repository.dart';
import 'package:shopnepal/features/supplier/presentation/cubit/supplier_form_cubit.dart';
import 'package:shopnepal/features/supplier/presentation/cubit/supplier_list_cubit.dart';
import 'package:shopnepal/features/supplier/presentation/widgets/supplier_form_sheet.dart';
import 'package:shopnepal/features/supplier/presentation/widgets/supplier_tile.dart';

/// Suppliers list, reached from the Catalog tab. Create/edit happens in a
/// bottom sheet (`SupplierFormSheet`) rather than a separate route — the same
/// shape login already uses for `LoginSheet` — so there is no second
/// `@RoutePage()` for what is really one screen with a modal form.
@RoutePage()
class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupplierListCubit(
        supplierRepository: RepositoryProvider.of<SupplierRepository>(
          context,
        ),
      )..fetchAll(),
      child: const _SupplierView(),
    );
  }
}

class _SupplierView extends StatelessWidget {
  const _SupplierView();

  Future<void> _openForm(BuildContext context, {Supplier? supplier}) async {
    final supplierRepository = RepositoryProvider.of<SupplierRepository>(
      context,
    );
    final listCubit = context.read<SupplierListCubit>();

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
        create: (_) =>
            SupplierFormCubit(supplierRepository: supplierRepository),
        child: SupplierFormSheet(supplier: supplier),
      ),
    );

    if (saved == true) listCubit.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Suppliers',
      body: RefreshIndicator(
        onRefresh: () => context.read<SupplierListCubit>().fetchAll(),
        child: BlocBuilder<SupplierListCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading || state is CommonInitial) {
              return const Center(child: CommonLoader());
            }

            if (state is CommonError) {
              return _ScrollableMessage(text: state.message);
            }

            if (state is CommonDataFetchSuccess<Supplier>) {
              final suppliers = state.data;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: suppliers.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];
                  return SupplierTile(
                    supplier: supplier,
                    onTap: () => _openForm(context, supplier: supplier),
                  );
                },
              );
            }

            return const _ScrollableMessage(
              text: 'No suppliers yet. Add one to get started.',
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppInsets.all16,
          child: PrimaryButton(
            text: 'Add supplier',
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
