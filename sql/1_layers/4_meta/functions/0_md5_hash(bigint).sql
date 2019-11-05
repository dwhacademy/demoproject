create or replace function md5_hash(bigint)
returns text as $$
select ($1::text)||'x';
$$ language sql;
