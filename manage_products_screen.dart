import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/firestore_service.dart';
import '../../customer/models/product_model.dart';
import '../widgets/product_image_picker_field.dart';

class ManageProductsScreen extends ConsumerStatefulWidget {
  final ProductModel? existingProduct;
  const ManageProductsScreen({super.key, this.existingProduct});

  @override
  ConsumerState<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends ConsumerState<ManageProductsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _priceCtrl;

  String _selectedCategory = 'Necklaces';
  String _selectedCarat = '22K BIS Hallmarked';
  String? _uploadedImageUrl;
  bool _isPriceOnRequest = false;
  bool _isTrending = false;
  bool _isNewArrival = true;

  @override
  void initState() {
    super.initState();
    final ProductModel? p = widget.existingProduct;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _weightCtrl = TextEditingController(text: p != null ? p.weightInGrams.toString() : '');
    _priceCtrl = TextEditingController(text: p?.fixedPrice != null ? p!.fixedPrice!.toStringAsFixed(0) : '');

    if (p != null) {
      _selectedCategory = p.category;
      _selectedCarat = p.carat;
      _isPriceOnRequest = p.isPriceOnRequest;
      _isTrending = p.isTrending;
      _isNewArrival = p.isNewArrival;
      if (p.mediaUrls.isNotEmpty) {
        _uploadedImageUrl = p.mediaUrls.first;
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _weightCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_uploadedImageUrl == null || _uploadedImageUrl!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.deepBrown,
            content: Text("Please snap or upload a photo of the jewellery first!"),
          ),
        );
        return;
      }

      final ProductModel product = ProductModel(
        id: widget.existingProduct?.id ?? '',
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _selectedCategory,
        collection: 'Wedding',
        weightInGrams: double.tryParse(_weightCtrl.text) ?? 0.0,
        carat: _selectedCarat,
        material: 'Gold',
        fixedPrice: _isPriceOnRequest ? null : double.tryParse(_priceCtrl.text),
        isPriceOnRequest: _isPriceOnRequest,
        mediaUrls: [_uploadedImageUrl!],
        isTrending: _isTrending,
        isNewArrival: _isNewArrival,
        isActive: true,
      );

      await ref.read(firestoreServiceProvider).upsertProduct(product);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jewellery item updated successfully in catalog.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: Text(widget.existingProduct == null ? "Add New Jewellery" : "Edit Item"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductImagePickerField(
                category: _selectedCategory,
                initialImageUrl: _uploadedImageUrl,
                onImageUploaded: (String? url) {
                  setState(() {
                    _uploadedImageUrl = url;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Design Title (e.g. Royal Punjabi Jhumkas)"),
                validator: (String? val) => val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: "Category"),
                items: ['Necklaces', 'Rings', 'Earrings', 'Bangles', 'Wedding']
                    .map((String c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                    .toList(),
                onChanged: (String? val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: "Weight (Grams)", suffixText: "g"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCarat,
                      decoration: const InputDecoration(labelText: "Purity / Carat"),
                      items: ['22K BIS Hallmarked', '18K Diamond Standard', 'Silver 925']
                          .map((String c) => DropdownMenuItem<String>(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (String? val) => setState(() => _selectedCarat = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text("Price on Request (Dynamic/Fluctuating)"),
                value: _isPriceOnRequest,
                activeColor: AppColors.orangeAccent,
                onChanged: (bool val) => setState(() => _isPriceOnRequest = val),
              ),
              if (!_isPriceOnRequest) ...[
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Fixed Making + Item Price (₹)"),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description / Craftsmanship Details"),
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text("Feature under 'Trending Designs'"),
                value: _isTrending,
                activeColor: AppColors.orangeAccent,
                onChanged: (bool? val) => setState(() => _isTrending = val ?? false),
              ),
              CheckboxListTile(
                title: const Text("Show as 'New Arrival'"),
                value: _isNewArrival,
                activeColor: AppColors.orangeAccent,
                onChanged: (bool? val) => setState(() => _isNewArrival = val ?? false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text("Save Item to Showcase"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}