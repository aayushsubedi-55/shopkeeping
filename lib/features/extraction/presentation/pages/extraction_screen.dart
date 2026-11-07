import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/widgets/page_wrapper.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/features/extraction/domain/entities/extraction.dart';
import 'package:shopnepal/features/extraction/domain/repositories/extraction_repository.dart';
import 'package:shopnepal/features/extraction/presentation/cubit/extraction_cubit.dart';
import 'package:shopnepal/features/extraction/presentation/widgets/extraction_result_sheet.dart';
import 'package:shopnepal/features/extraction/presentation/widgets/extraction_upload_widget.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

@RoutePage()
class ExtractionScreen extends StatelessWidget {
  const ExtractionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExtractionCubit(
        repository: RepositoryProvider.of<ExtractionRepository>(context),
      ),
      child: const _ExtractionScreenView(),
    );
  }
}

class _ExtractionScreenView extends StatelessWidget {
  const _ExtractionScreenView();

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: AppStrings.extractFromPhoto,
      body: BlocBuilder<ExtractionCubit, CommonState>(
        builder: (context, state) {
          if (state is CommonLoading && state is! CommonStateSuccess) {
            return const Center(child: CommonLoader());
          }

          if (state is CommonError) {
            return Column(
              children: [
                const ExtractionUploadWidget(),
                const SizedBox(height: AppSpacing.s16),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error, color: Theme.of(context).colorScheme.error),
                            const SizedBox(width: AppSpacing.s8),
                            Text(
                              AppStrings.extractionFailed,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        Text(state.message),
                        const SizedBox(height: AppSpacing.s16),
                        ElevatedButton(
                          onPressed: () => context.read<ExtractionCubit>().reset(),
                          child: const Text(AppStrings.tryAgain),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is CommonStateSuccess) {
            final extractedSheet = state.data as ExtractedSheet;
            return Column(
              children: [
                const ExtractionUploadWidget(),
                const SizedBox(height: AppSpacing.s16),
                ExtractionResultSheet(extractedSheet: extractedSheet),
              ],
            );
          }

          return const ExtractionUploadWidget();
        },
      ),
    );
  }
}