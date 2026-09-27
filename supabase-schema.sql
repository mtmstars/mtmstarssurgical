-- MTM Stars Surgical Website — Supabase setup
-- Run this whole script in Supabase SQL Editor.
-- Then create your admin user in Authentication > Users.
create extension if not exists pgcrypto;

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique,
  description text default '',
  icon text default '⚕',
  image_url text default '',
  sort_order integer default 0,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price numeric(12,2) not null default 0,
  category text default '',
  tag text default '',
  image_url text default '',
  gallery_urls text[] default '{}',
  video_urls text[] default '{}',
  description text default '',
  sort_order integer default 0,
  featured boolean default true,
  active boolean default true,
  created_at timestamptz default now()
);

alter table public.products add column if not exists gallery_urls text[] default '{}';
alter table public.products add column if not exists video_urls text[] default '{}';

create table if not exists public.site_settings (
  key text primary key,
  value text default ''
);

create table if not exists public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  contact text not null,
  message text not null,
  created_at timestamptz default now()
);

alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.site_settings enable row level security;
alter table public.contact_messages enable row level security;

drop policy if exists "public read active categories" on public.categories;
create policy "public read active categories" on public.categories for select using (active = true);
drop policy if exists "public read active products" on public.products;
create policy "public read active products" on public.products for select using (active = true);
drop policy if exists "public read site settings" on public.site_settings;
create policy "public read site settings" on public.site_settings for select using (true);
drop policy if exists "public insert contact messages" on public.contact_messages;
create policy "public insert contact messages" on public.contact_messages for insert with check (true);

drop policy if exists "authenticated manage categories" on public.categories;
create policy "authenticated manage categories" on public.categories for all to authenticated using (true) with check (true);
drop policy if exists "authenticated manage products" on public.products;
create policy "authenticated manage products" on public.products for all to authenticated using (true) with check (true);
drop policy if exists "authenticated manage settings" on public.site_settings;
create policy "authenticated manage settings" on public.site_settings for all to authenticated using (true) with check (true);
drop policy if exists "authenticated read messages" on public.contact_messages;
create policy "authenticated read messages" on public.contact_messages for select to authenticated using (true);
drop policy if exists "authenticated delete messages" on public.contact_messages;
create policy "authenticated delete messages" on public.contact_messages for delete to authenticated using (true);

-- Storage: public read, authenticated upload/update/delete.
insert into storage.buckets (id, name, public)
values ('mtm-media', 'mtm-media', true)
on conflict (id) do update set public = true;

drop policy if exists "Public read MTM media" on storage.objects;
create policy "Public read MTM media" on storage.objects for select using (bucket_id = 'mtm-media');

drop policy if exists "Authenticated upload MTM media" on storage.objects;
create policy "Authenticated upload MTM media" on storage.objects for insert to authenticated with check (bucket_id = 'mtm-media');

drop policy if exists "Authenticated update MTM media" on storage.objects;
create policy "Authenticated update MTM media" on storage.objects for update to authenticated using (bucket_id = 'mtm-media') with check (bucket_id = 'mtm-media');

drop policy if exists "Authenticated delete MTM media" on storage.objects;
create policy "Authenticated delete MTM media" on storage.objects for delete to authenticated using (bucket_id = 'mtm-media');

insert into public.categories (name,slug,description,icon,sort_order)
values
('Surgical Instruments','surgical-instruments','Precision instruments for procedures.','⚕',1),
('Dental Instruments','dental-instruments','Professional dental tools.','✚',2),
('Orthopedic','orthopedic','Orthopedic & trauma equipment.','◈',3),
('Diagnostic Equipment','diagnostic-equipment','Clinical diagnostic essentials.','⌁',4)
on conflict (slug) do nothing;

insert into public.products (name,price,category,tag,description,sort_order,featured,active)
select * from (values
('Surgical Scissors',2500,'Surgical Instruments','PRO','Precision surgical scissors.',1,true,true),
('Mayo Dissecting Scissors',3200,'Surgical Instruments','','Professional dissecting scissors.',2,true,true),
('Adson Tissue Forceps',1800,'Surgical Instruments','','Fine tissue handling instrument.',3,true,true),
('Dental Extraction Forceps',2200,'Dental Instruments','NEW','Dental extraction instrument.',4,true,true),
('Bone Rongeur',6800,'Orthopedic','','Orthopedic bone instrument.',5,true,true),
('Diagnostic Stethoscope',4500,'Diagnostic Equipment','','Clinical diagnostic essential.',6,true,true),
('Needle Holder',2400,'Surgical Instruments','','Reliable needle handling instrument.',7,true,true),
('Laryngoscope Set',9500,'Diagnostic Equipment','','Professional diagnostic set.',8,true,true)
) as v(name,price,category,tag,description,sort_order,featured,active)
where not exists (select 1 from public.products p where p.name=v.name);

insert into public.site_settings(key,value) values
('phone','03250615786 / 03336159786'),
('email',''),('address',''),
('whatsapp','923250615786'),
('about_title','More than a supplier. A professional partner.'),
('about_text','MTM Stars provides surgical instruments, medical supplies and healthcare equipment for clinics, hospitals, professionals and distributors.'),
('about_image_url',''),('about_pillars','Precision|Reliability|Service'),('about_video_urls','[]')
on conflict (key) do nothing;
