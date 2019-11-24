create or replace function md5_hash(bigint)
returns text as $$
select coalesce(md5($1::text),'x');
$$ language sql;
