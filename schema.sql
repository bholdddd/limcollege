-- lim.college database setup
-- Paste this whole file into Supabase → SQL Editor → New query, then click Run. It is safe to run more than once.

-- Public player cards: the leaderboard, search and profile pages read these.
create table if not exists public.players (
  id          uuid primary key references auth.users (id) on delete cascade,
  handle      text not null unique check (handle ~ '^[a-z0-9_.-]{3,20}$'),
  username    text not null check (char_length(username) between 3 and 20),
  bio         text not null default '' check (char_length(bio) <= 160),
  school      text not null default '' check (char_length(school) <= 80),
  year        text not null default '' check (char_length(year) <= 40),
  socials     jsonb not null default '{}'::jsonb,
  has_avatar  boolean not null default false,
  avv         bigint not null default 0,
  rating      integer not null default 500 check (rating between 0 and 5000),
  peak        integer not null default 500 check (peak between 0 and 5000),
  solved      integer not null default 0 check (solved >= 0),
  solved_by   jsonb not null default '{}'::jsonb,
  n           integer not null default 0,
  hist        jsonb not null default '[]'::jsonb,
  recent      jsonb not null default '[]'::jsonb,
  mastery     jsonb not null default '{}'::jsonb,
  cs          jsonb not null default '{}'::jsonb,
  joined      bigint,
  updated     bigint,
  check (pg_column_size(socials) + pg_column_size(hist) + pg_column_size(recent) + pg_column_size(mastery) + pg_column_size(cs) + pg_column_size(solved_by) < 32000)
);
create index if not exists players_rating_idx on public.players (rating desc);

-- Each player's full private progress (attempts, cooldowns, history). Only the owner can read it.
create table if not exists public.progress (
  id          uuid primary key references auth.users (id) on delete cascade,
  state       jsonb not null check (pg_column_size(state) < 1000000),
  updated_at  timestamptz not null default now()
);

-- Profile pictures, stored as small data URLs (the site crops them to 192×192).
create table if not exists public.avatars (
  id   uuid primary key references auth.users (id) on delete cascade,
  img  text not null check (char_length(img) < 300000 and img ~ '^data:image/(jpeg|png|webp);base64,'),
  v    bigint not null default 0
);

alter table public.players  enable row level security;
alter table public.progress enable row level security;
alter table public.avatars  enable row level security;

drop policy if exists "players are public"   on public.players;
drop policy if exists "insert own player"    on public.players;
drop policy if exists "update own player"    on public.players;
create policy "players are public" on public.players for select using (true);
create policy "insert own player"  on public.players for insert with check (auth.uid() = id);
create policy "update own player"  on public.players for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "read own progress"    on public.progress;
drop policy if exists "insert own progress"  on public.progress;
drop policy if exists "update own progress"  on public.progress;
create policy "read own progress"   on public.progress for select using (auth.uid() = id);
create policy "insert own progress" on public.progress for insert with check (auth.uid() = id);
create policy "update own progress" on public.progress for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "avatars are public"   on public.avatars;
drop policy if exists "insert own avatar"    on public.avatars;
drop policy if exists "update own avatar"    on public.avatars;
drop policy if exists "delete own avatar"    on public.avatars;
create policy "avatars are public" on public.avatars for select using (true);
create policy "insert own avatar"  on public.avatars for insert with check (auth.uid() = id);
create policy "update own avatar"  on public.avatars for update using (auth.uid() = id) with check (auth.uid() = id);
create policy "delete own avatar"  on public.avatars for delete using (auth.uid() = id);
