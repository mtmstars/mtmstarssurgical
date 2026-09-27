# MTM Stars — Premium Surgical Website

Included:
- index.html — premium public home page
- category.html — dedicated category page
- product.html — dedicated product detail page with gallery, videos and WhatsApp Contact Us
- admin.html — Supabase login + full admin panel
- supabase-schema.sql — database + Storage bucket/policies
- supabase-config.js — add your Supabase URL + publishable/anon key
- logo.png — supplied MTM Stars logo

## What was changed
1. Shop/Product buttons are now Contact Us / WhatsApp instead of buying.
2. Every product opens its own detail page.
3. Every category opens its own page and lists products from Supabase.
4. Admin can add/edit/delete categories and upload category pictures.
5. Admin can add/edit/delete products, upload a main image, multiple gallery images and multiple product videos.
6. Admin can upload an About Us image and multiple About Us videos.
7. Logo is embedded directly into the public HTML pages, so it remains visible without relying on a separate logo file.
8. Hero section includes a subtle embedded surgical-instrument illustration behind “Precision for Every Procedure”.
9. WhatsApp number is managed from Site Settings. The supplied starter value is 923250615786 and can be changed there.

## Supabase setup
1. Open Supabase SQL Editor and run `supabase-schema.sql`.
2. Create an admin user in Authentication > Users.
3. Put your Supabase Project URL and publishable/anon key in `supabase-config.js`.
4. Upload all files to the same hosting folder.
5. Open `admin.html` and sign in.
6. Use Site Settings to confirm the WhatsApp number.
7. Use Categories / Products / Site Settings to upload and manage media.

The Storage bucket `mtm-media` is public for reading so the public website can display uploaded media. Only authenticated users can upload/update/delete files.

For production with multiple admin users, replace the simple authenticated CRUD policies with a dedicated admin-role policy.
