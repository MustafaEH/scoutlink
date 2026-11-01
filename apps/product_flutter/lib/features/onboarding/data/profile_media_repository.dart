import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileMediaFailure implements Exception {
  const ProfileMediaFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

class ProfileMediaRepository {
  ProfileMediaRepository(this.client);
  final SupabaseClient client;

  static const bucket = 'profile-images';
  static const maxBytes = 5 * 1024 * 1024;

  Future<String> uploadAvatar(String localPath) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw const ProfileMediaFailure(
        'Sign in before uploading a profile photo.',
      );
    }
    final file = File(localPath);
    if (!await file.exists()) {
      throw const ProfileMediaFailure(
        'The selected photo is no longer available. Choose it again.',
      );
    }
    if (await file.length() > maxBytes) {
      throw const ProfileMediaFailure(
        'Choose a profile photo smaller than 5 MB.',
      );
    }
    final extension = localPath.split('.').last.toLowerCase();
    if (!{'jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'}.contains(extension)) {
      throw const ProfileMediaFailure(
        'Choose a JPEG, PNG, WebP, or HEIC profile photo.',
      );
    }
    final contentType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'heic' || 'heif' => 'image/heic',
      _ => 'image/jpeg',
    };
    final safeExtension = switch (contentType) {
      'image/png' => 'png',
      'image/webp' => 'webp',
      'image/heic' => 'heic',
      _ => 'jpg',
    };
    final objectPath = '${user.id}/avatar.$safeExtension';
    try {
      await client.storage
          .from(bucket)
          .upload(
            objectPath,
            file,
            fileOptions: FileOptions(
              upsert: true,
              contentType: contentType,
              cacheControl: '3600',
            ),
          );
      return objectPath;
    } on StorageException catch (error) {
      throw ProfileMediaFailure(
        error.message.isEmpty
            ? 'We could not upload the profile photo. Try again.'
            : error.message,
      );
    }
  }
}
