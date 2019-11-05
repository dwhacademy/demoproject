create or replace function md5(varchar)
returns text as $$
select coalesce(($1::text),md5(1));
$$ language sql immutable;
