# Flutter Chat サンプル

このアプリはFlutterとSupabaseを使って作られたシンプルなチャットアプリです。詳細な作り方のステップは[こちら](https://zenn.dev/dshukertjr/books/flutter-supabase-chat)にまとめてあります。

## 環境構築用のSQL

```sql
-- テーブル定義
create table if not exists public.profiles (
    id uuid references auth.users on delete cascade not null primary key,
    username varchar(24) not null unique,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null,

    -- ユーザー名にRegexを使って制限をかける
    constraint username_validation check (username ~* '^[A-Za-z0-9_]{3,24}$')
);
comment on table public.profiles is 'ユーザー名などのユーザー情報を保持する';

create table if not exists public.messages (
    id uuid not null primary key default uuid_generate_v4(),
    profile_id uuid default auth.uid() references public.profiles(id) on delete cascade not null,
    content varchar(500) not null,
    created_at timestamp with time zone default timezone('utc' :: text, now()) not null
);
comment on table public.messages is 'アプリ内で送られたチャットを保持する';

-- *** Realtimeを有効化する。UIからも編集可能 ***
alter publication supabase_realtime add table public.messages;


--　auth.usersからユーザー名を抜き取ってprofilesテーブルに挿入するfunction
create or replace function handle_new_user() returns trigger as $$
    begin
        insert into public.profiles(id, username)
        values(new.id, new.raw_user_meta_data->>'username');

        return new;
    end;
$$ language plpgsql security definer;

-- 上記functionを呼ぶトリガー。auth.usersにinsertされたらhandle_new_user()を呼ぶ
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function handle_new_user();
```
