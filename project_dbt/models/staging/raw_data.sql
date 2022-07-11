    ---  convert json to text use jsonb
    
    select  
    channel::jsonb->0->'guid'::text as call_guid, 
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->0->'party'->>'id')::int as pagent_id,
    (replace(duration,',','')::int)/1000 as total_duration_sec,
    channel::json->0->'endReason' as call_end_reason
    from table3
    where channel::json->0->'party'->>'id' is not null

    union all
    
    select   
    channel::jsonb->1->'guid'::text as call_guid,
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->1->'party'->>'id')::int as pagent_id,
    (replace(duration,',','')::int)/1000 as total_duration_sec,
    
    channel::json->1->'endReason' as call_end_reason
    from table3
    where channel::json->1->'party'->>'id' is not null
    
    union all
    
    select   channel::jsonb->2->'guid'::text as call_guid,
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->2->'party'->>'id')::int as pagent_id,
    (replace(duration,',','')::int)/1000 total_duration_sec,
    
    channel::json->2->'endReason' as call_end_reason
    from table3
    where channel::json->2->'party'->>'id' is not null