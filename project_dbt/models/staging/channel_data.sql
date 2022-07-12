
-- creating a separate model to unstructure the event data in channel
 
select   channel::jsonb->0->>'guid' as call_guid, 
channel::json->0->'events' as etype from table7


union all

select  channel::jsonb->1->>'guid' as call_guid,
channel::json->1->'events' as etype from table7

union all

select  channel::jsonb->2->>'guid' as call_guid,
channel::json->2->'events' as etype from table7