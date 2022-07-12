    ---  transforming all data as mentioned in the case study
    
    select  
    channel::jsonb->0->>'guid' as call_guid, 
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->0->'party'->>'id')::int as pagent_id,
    channel::json->0->'endReason' as call_end_reason
    from table7
    where channel::json->0->'party'->>'id' is not null

    union all
    
    select   
    channel::jsonb->1->>'guid' as call_guid,
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->1->'party'->>'id')::int as pagent_id,
    channel::json->1->'endReason' as call_end_reason
    from table7
    where channel::json->1->'party'->>'id' is not null
    
    union all
    
    select   channel::jsonb->2->>'guid' as call_guid,
    start_time::timestamp as timestamp_of_call_start,
    (channel::json->2->'party'->>'id')::int as pagent_id,
    channel::json->2->'endReason' as call_end_reason
    from table7
    where channel::json->2->'party'->>'id' is not null