create or replace function md5_hash(varchar)
returns text as $$
select coalesce(($1::text),md5(1));
$$ language sql immutable;
