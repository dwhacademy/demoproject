create function md5(bigint)
returns text as $$
select md5($1::text);
$$ language sql immutable;

create function md5(integer)
returns text as $$
select md5($1::text);
$$ language sql immutable;