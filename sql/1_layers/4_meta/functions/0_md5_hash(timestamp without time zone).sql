create or replace function md5_hash(timestamp without time zone)
returns text as $$
select coalesce(md5($1::text),'x');
$$ language sql;
