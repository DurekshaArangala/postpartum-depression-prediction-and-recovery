-- Run in Supabase: SQL Editor -> New query -> paste -> Run
create extension if not exists "pgcrypto";

-- ---------- Public content (shown on the Gentle support screen) ----------
create table if not exists app_settings (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists support_cards (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  body text not null,
  icon text not null,            -- e.g. 'moon', 'users', 'cup' (mapped in the app)
  color text not null,           -- hex accent for the icon tile
  sort_order int not null default 0,
  locale text not null default 'en',
  is_active boolean not null default true
);

create table if not exists helplines (
  id uuid primary key default gen_random_uuid(),
  country_code char(2) not null,
  name text not null,
  phone text not null,
  kind text not null check (kind in ('mental_health','emergency')),
  sort_order int not null default 0,
  is_active boolean not null default true
);
create index if not exists helplines_country_idx on helplines(country_code, sort_order);

-- ---------- User data ----------
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  country_code char(2) not null default 'LK',
  created_at timestamptz not null default now()
);

create table if not exists breathing_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  duration_seconds int not null check (duration_seconds between 1 and 3600),
  cycles int not null default 0 check (cycles >= 0),
  created_at timestamptz not null default now()
);
create index if not exists breathing_user_idx on breathing_sessions(user_id, created_at desc);

create table if not exists mood_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mood smallint not null check (mood between 1 and 5),  -- 1 very low ... 5 very good
  note text check (char_length(note) <= 1000),
  created_at timestamptz not null default now()
);
create index if not exists mood_user_idx on mood_logs(user_id, created_at desc);

create table if not exists care_checkins (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  card_slug text not null references support_cards(slug) on delete cascade,
  created_at timestamptz not null default now()
);
create index if not exists care_user_idx on care_checkins(user_id, created_at desc);

-- ---------- Row Level Security ----------
alter table app_settings       enable row level security;
alter table support_cards      enable row level security;
alter table helplines          enable row level security;
alter table profiles           enable row level security;
alter table breathing_sessions enable row level security;
alter table mood_logs          enable row level security;
alter table care_checkins      enable row level security;

create policy "public read settings" on app_settings  for select using (true);
create policy "public read cards"    on support_cards for select using (is_active);
create policy "public read helplines" on helplines    for select using (is_active);

create policy "own profile"   on profiles           for all using (auth.uid() = id)      with check (auth.uid() = id);
create policy "own breathing" on breathing_sessions for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own mood"      on mood_logs          for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own care"      on care_checkins      for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Auto-create a profile when a user signs up
create or replace function handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into profiles (id) values (new.id) on conflict do nothing;
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function handle_new_user();

-- ---------- Seed data (from the screens) ----------
insert into app_settings (key, value) values
 ('gentle_support_header', '{"title":"Be gentle with yourself","subtitle":"A few small things that may help today."}'),
 ('breathing', '{"title":"Take a minute to breathe","subtitle":"Follow the circle. Slowly in, slowly out.","inhale_seconds":4,"exhale_seconds":6,"default_duration_seconds":60}'),
 ('help_now_notice', '{"title":"If you need help right now","body":"If sadness, anxiety, or distress is persistent or worsening, speak with a qualified healthcare professional. For immediate danger or thoughts of self-harm, seek urgent help."}')
on conflict (key) do nothing;

insert into support_cards (slug, title, body, icon, color, sort_order) values
 ('rest', 'Rest when you can', 'Even a short rest may help you recharge. Ask someone you trust to help if possible.', 'moon', '#A99BEA', 1),
 ('connect', 'Stay connected', 'Share how you feel with someone you trust. You do not need to handle everything alone.', 'users', '#E06A9B', 2),
 ('care', 'Small moments of care', 'Have some water, eat regularly, and give yourself permission to take a break.', 'cup', '#E8A04C', 3)
on conflict (slug) do nothing;

insert into helplines (country_code, name, phone, kind, sort_order) values
 ('LK', 'National Mental Health Helpline (Sri Lanka)', '1926', 'mental_health', 1),
 ('LK', 'Emergency ambulance', '1990', 'emergency', 2);
