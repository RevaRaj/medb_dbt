
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

-- ->> used to convert json to int

with source_data as (
    
    select   channel::json->0->'guid' as call_guid,
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->0->'party'->>'id')::int as pagent_id,
    replace(duration,',','')::int as total_duration,
    channel::json->0->'events' as etype,      
    channel::json->0->'endReason' as call_end_reason
    from table3

    union all
    
    select   channel::json->1->'guid' as call_guid,
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->1->'party'->>'id')::int as pagent_id,
    replace(duration,',','')::int as total_duration,
    channel::json->1->'events' as etype,      
    channel::json->1->'endReason' as call_end_reason
    from table3
    
    union all
    
    select   channel::json->2->'guid' as call_guid,
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->2->'party'->>'id')::int as pagent_id,
    replace(duration,',','')::int as total_duration,
    channel::json->2->'events' as etype,      
    channel::json->2->'endReason' as call_end_reason
    from table3
)

select *
from source_data 
--where etype->0->>'type' = any('{Ringing,Connected,wrap}')
where call_guid is not null
order by pagent_id

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
