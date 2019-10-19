create or replace  function md5(numeric)
returns text as $$
select md5($1::text);
$$ language sql immutable;
