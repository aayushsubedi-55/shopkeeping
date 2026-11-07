import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/extraction/presentation/cubit/extraction_cubit.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class ExtractionUploadWidget extends StatelessWidget {
  const ExtractionUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtractionCubit, CommonState>(
      builder: (context, state) {
        final isLoading = state is CommonLoading;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.s16),
                Text(
                  AppStrings.extractFromPhoto,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  AppStrings.extractDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : () => _pickImage(context, ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text(AppStrings.takePhoto),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : () => _pickImage(context, ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text(AppStrings.chooseFromGallery),
                      ),
                    ),
                  ],
                ),
                if (isLoading) ...[
                  const SizedBox(height: AppSpacing.s16),
                  const CommonLoader(),
                  const SizedBox(height: AppSpacing.s8),
                  Text(AppStrings.extracting),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (xFile != null && context.mounted) {
      context.read<ExtractionCubit>().extract(File(xFile.path));
    }
  }
}