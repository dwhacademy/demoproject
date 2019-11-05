create or replace  function md5_hash(numeric)
returns text as $$
select ($1::text)||'x';
$$ language sql immutable;
