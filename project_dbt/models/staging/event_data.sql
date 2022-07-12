    -- converting call_stage to text so that it can be used in groupby else will get "equality operator for type json"

 
            
    select call_guid,
        etype::jsonb->0->>'type' as call_type,
        ((etype::json->0->>'duration')::int)/1000 as call_duration
        from {{ ref("channel_data") }}
         where etype is not null

    union all

     select call_guid,
        etype::jsonb->1->>'type' as call_type,
        ((etype::json->1->>'duration')::int)/1000 as call_duration
        from {{ ref("channel_data") }}
         where etype is not null

    union all

     select call_guid,
        etype::jsonb->2->>'type' as call_type,
        ((etype::json->2->>'duration')::int)/1000 as call_duration
        from {{ ref("channel_data") }}
         where etype is not null

    union all

     select call_guid,
        etype::jsonb->3->>'type' as call_type,
        ((etype::json->3->>'duration')::int)/1000 as call_duration
        from {{ ref("channel_data") }}
         where etype is not null

    union all
    
     select call_guid,
        etype::jsonb->4->>'type' as call_type,
        ((etype::json->4->>'duration')::int)/1000 as call_duration
        from {{ ref("channel_data") }}
         where etype is not null
