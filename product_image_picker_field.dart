import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/storage_service.dart';

class ProductImagePickerField extends ConsumerStatefulWidget {
  final String category;
  final String? initialImageUrl;
  final ValueChanged<String?> onImageUploaded;

  const ProductImagePickerField({
    super.key,
    required this.category,
    this.initialImageUrl,
    required this.onImageUploaded,
  });

  @override
  ConsumerState<ProductImagePickerField> createState() => _ProductImagePickerFieldState();
}

class _ProductImagePickerFieldState extends ConsumerState<ProductImagePickerField> {
  XFile? _localFile;
  String? _remoteUrl;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _remoteUrl = widget.initialImageUrl;
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final StorageService storage = ref.read(storageServiceProvider);
    final XFile? file = await storage.pickImage(source);
    if (file == null) return;

    setState(() {
      _localFile = file;
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final String downloadUrl = await storage.uploadProductImage(
        file: file,
        productCategory: widget.category,
        onProgress: (double p) {
          setState(() {
            _uploadProgress = p;
          });
        },
      );

      setState(() {
        _remoteUrl = downloadUrl;
        _isUploading = false;
      });

      widget.onImageUploaded(downloadUrl);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            content: Text("Upload failed: $e"),
          ),
        );
      }
    }
  }

  void _showSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.creamBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Capture Jewellery Photo",
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBrown,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.goldenYellow,
                  child: Icon(Icons.camera_alt, color: AppColors.deepBrown),
                ),
                title: const Text("Take Live Photo (Camera)", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Capture jewellery directly under showroom lighting"),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUpload(ImageSource.camera);
                },
              ),
              const Divider(color: AppColors.subtleDivider),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.goldenYellow,
                  child: Icon(Icons.photo_library, color: AppColors.deepBrown),
                ),
                title: const Text("Select from Gallery / Library", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Choose an existing studio or catalog shot"),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUpload(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _localFile = null;
      _remoteUrl = null;
    });
    widget.onImageUploaded(null);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = _localFile != null || (_remoteUrl != null && _remoteUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Jewellery Visual Showcase",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.deepBrown),
        ),
        const SizedBox(height: 8),
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasImage ? AppColors.goldenYellow : AppColors.subtleDivider,
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_localFile != null)
                  kIsWeb
                      ? Image.network(_localFile!.path, fit: BoxFit.cover)
                      : Image.file(File(_localFile!.path), fit: BoxFit.cover)
                else if (_remoteUrl != null && _remoteUrl!.isNotEmpty)
                  Image.network(
                    _remoteUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext _, Widget child, ImageChunkEvent? progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator(color: AppColors.deepBrown));
                    },
                    errorBuilder: (BuildContext _, Object __, StackTrace? ___) => const Center(
                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  )
                else
                  InkWell(
                    onTap: _showSourceBottomSheet,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.creamBackground,
                          child: Icon(Icons.add_a_photo_outlined, size: 30, color: AppColors.orangeAccent),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Tap to add jewellery photo",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Camera or Gallery • Auto-compressed for quality",
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                if (_isUploading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _uploadProgress > 0 ? _uploadProgress : null,
                          color: AppColors.goldenYellow,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Uploading to Cloud... ${(_uploadProgress * 100).toInt()}%",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                if (hasImage && !_isUploading)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit, size: 18, color: AppColors.deepBrown),
                            onPressed: _showSourceBottomSheet,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                            onPressed: _removeImage,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}