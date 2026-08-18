-- Query: Create the lgu-docs public storage bucket for direct document
-- uploads (PDF, Word, Excel) in the Public Documents / Transparency
-- section admin panel.
-- Run in Supabase → SQL Editor → New Query → Run.

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'lgu-docs', 'lgu-docs', true,
  15728640, -- 15 MB
  ARRAY[
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'image/png', 'image/jpeg', 'image/webp'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = true,
  file_size_limit = 15728640,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Public read access (so document links work for any visitor)
DROP POLICY IF EXISTS "lgu_docs_public_read" ON storage.objects;
CREATE POLICY "lgu_docs_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'lgu-docs');

-- Public upload (admin panel's own login gates access at the UI level,
-- same trust model already used for lgu-images and lgu_kv)
DROP POLICY IF EXISTS "lgu_docs_public_insert" ON storage.objects;
CREATE POLICY "lgu_docs_public_insert" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'lgu-docs');

-- Public delete (so removing/replacing a document also removes its file)
DROP POLICY IF EXISTS "lgu_docs_public_delete" ON storage.objects;
CREATE POLICY "lgu_docs_public_delete" ON storage.objects
  FOR DELETE USING (bucket_id = 'lgu-docs');
