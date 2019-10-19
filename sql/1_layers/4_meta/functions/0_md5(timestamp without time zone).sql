create or replace  function md5(timestamp without time zone)
returns text as $$
select md5($1::text);
$$ language sql immutable;
