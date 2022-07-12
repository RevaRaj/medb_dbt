  select call_guid,    
    call_duration as {{var('connect_stage')}}
    from {{ ref('event_data')}}
    where call_type = '{{var("connect")}}'