create or replace  function md5_hash(integer)
returns text as $$
select ($1::text)||'x';
$$ language sql immutable;
