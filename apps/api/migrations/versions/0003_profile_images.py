"""Create the private profile image bucket and owner-only policies.

Revision ID: 0003_profile_images
Revises: 0002_onboarding_profiles
Create Date: 2026-10-31
"""

from collections.abc import Sequence

from alembic import op

revision: str = "0003_profile_images"
down_revision: str | None = "0002_onboarding_profiles"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.execute(
        """
        INSERT INTO storage.buckets (
            id, name, public, file_size_limit, allowed_mime_types
        ) VALUES (
            'profile-images',
            'profile-images',
            false,
            5242880,
            ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/heic']
        )
        ON CONFLICT (id) DO UPDATE SET
            public = EXCLUDED.public,
            file_size_limit = EXCLUDED.file_size_limit,
            allowed_mime_types = EXCLUDED.allowed_mime_types
        """
    )
    op.execute(
        """
        CREATE POLICY "profile_images_insert_own"
        ON storage.objects FOR INSERT TO authenticated
        WITH CHECK (
            bucket_id = 'profile-images'
            AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
        )
        """
    )
    op.execute(
        """
        CREATE POLICY "profile_images_select_own"
        ON storage.objects FOR SELECT TO authenticated
        USING (
            bucket_id = 'profile-images'
            AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
        )
        """
    )
    op.execute(
        """
        CREATE POLICY "profile_images_update_own"
        ON storage.objects FOR UPDATE TO authenticated
        USING (
            bucket_id = 'profile-images'
            AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
        )
        WITH CHECK (
            bucket_id = 'profile-images'
            AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
        )
        """
    )
    op.execute(
        """
        CREATE POLICY "profile_images_delete_own"
        ON storage.objects FOR DELETE TO authenticated
        USING (
            bucket_id = 'profile-images'
            AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
        )
        """
    )


def downgrade() -> None:
    op.execute('DROP POLICY IF EXISTS "profile_images_delete_own" ON storage.objects')
    op.execute('DROP POLICY IF EXISTS "profile_images_update_own" ON storage.objects')
    op.execute('DROP POLICY IF EXISTS "profile_images_select_own" ON storage.objects')
    op.execute('DROP POLICY IF EXISTS "profile_images_insert_own" ON storage.objects')
    op.execute("DELETE FROM storage.buckets WHERE id = 'profile-images'")
