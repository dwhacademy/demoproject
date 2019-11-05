create or replace function md5_hash(timestamp without time zone)
returns text as $$
select ($1::text)||'x';
$$ language sql immutable;
