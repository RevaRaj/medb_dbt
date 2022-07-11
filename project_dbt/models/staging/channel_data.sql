

select   channel::jsonb->0->'guid'::text as call_guid, 
channel::json->0->'events' as etype from table3


union all

select  channel::jsonb->1->'guid'::text as call_guid,
channel::json->1->'events' as etype from table3

union all

select  channel::jsonb->2->'guid'::text as call_guid,
channel::json->2->'events' as etype from table3