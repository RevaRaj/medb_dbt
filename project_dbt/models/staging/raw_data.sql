---  Except events transforming all data here

with raw_data1 as (

        select  
                channel::jsonb->0->>'guid' as call_guid, 
                start_time::timestamp as timestamp_of_call_start,               --  Transforming start time to timestamp    
                (channel::json->0->'party'->>'id')::int as pagent_id,           --  Extracting participating agent id from channel column 
                channel::json->0->>'endReason' as call_end_reason               
        from    table6
        where   channel::json->0->'party'->>'id' is not null                    --  Some calls have no particapating agent hence removing them
),

raw_data2 as (

        select   
                channel::jsonb->1->>'guid' as call_guid,
                start_time::timestamp as timestamp_of_call_start,
                (channel::json->1->'party'->>'id')::int as pagent_id,
                channel::json->1->>'endReason' as call_end_reason
        from    table6
        where   channel::json->1->'party'->>'id' is not null
),

raw_data3 as (

        select   
                channel::jsonb->2->>'guid' as call_guid,
                start_time::timestamp as timestamp_of_call_start,
                (channel::json->2->'party'->>'id')::int as pagent_id,
                channel::json->2->>'endReason' as call_end_reason
        from    table6
        where   channel::json->2->'party'->>'id' is not null
),

-- Combining all above data into single
final_other_data as (

        select * from raw_data1
        union all
        select * from raw_data2
        union all
        select * from raw_data3
)

select * from final_other_data