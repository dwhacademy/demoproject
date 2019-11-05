create or replace function md5_hash(varchar)
returns text as $$
select ($1::text)||'x';
$$ language sql immutable;
