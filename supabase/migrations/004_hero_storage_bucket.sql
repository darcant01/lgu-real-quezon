-- Query: Create (or fix) the lgu-images public storage bucket used for
-- hero slideshow images (and future public image uploads).
--
-- Why this is needed: images uploaded through the admin panel previously
-- lived only in the uploading browser's localStorage, so they were never
-- actually visible to real site visitors (mobile or otherwise) — only to
-- the same browser/device that uploaded them. This bucket is what makes
-- uploaded images visible to everyone.

-- Create the bucket if it doesn't already exist, and make sure it's public
INSERT INTO storage.buckets (id, name, public)
VALUES ('lgu-images', 'lgu-images', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Public read access (so <img> tags on the live site can load files)
DROP POLICY IF EXISTS "lgu_images_public_read" ON storage.objects;
CREATE POLICY "lgu_images_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'lgu-images');

-- Public upload (admin panel's own login gates access at the UI level,
-- same trust model already used for the lgu_kv table)
DROP POLICY IF EXISTS "lgu_images_public_insert" ON storage.objects;
CREATE POLICY "lgu_images_public_insert" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'lgu-images');

-- Public delete (so removing a hero slide can also remove its file)
DROP POLICY IF EXISTS "lgu_images_public_delete" ON storage.objects;
CREATE POLICY "lgu_images_public_delete" ON storage.objects
  FOR DELETE USING (bucket_id = 'lgu-images');
