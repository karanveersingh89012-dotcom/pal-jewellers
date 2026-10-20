import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(
    FirebaseStorage.instance,
    ImagePicker(),
  );
});

class StorageService {
  final FirebaseStorage _storage;
  final ImagePicker _picker;

  StorageService(this._storage, this._picker);

  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 82,
      );
      return image;
    } catch (e) {
      debugPrint("Error picking image: $e");
      return null;
    }
  }

  Future<String> uploadProductImage({
    required XFile file,
    required String productCategory,
    void Function(double progress)? onProgress,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sanitizedCategory = productCategory.toLowerCase().replaceAll(' ', '_');
    final storagePath = 'catalog/$sanitizedCategory/pj_${timestamp}.jpg';

    final ref = _storage.ref().child(storagePath);
    final Uint8List fileBytes = await file.readAsBytes();

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'uploadedBy': 'Pal Jewellers Admin',
        'timestamp': timestamp.toString(),
      },
    );

    final UploadTask uploadTask = ref.putData(fileBytes, metadata);

    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });
    }

    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteImageByUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      debugPrint("Could not delete image: $e");
    }
  }
}