    
    
    select call_guid,    
    call_duration as {{var('ring_stage')}}
    from {{ ref('event_data')}}
    where call_type = '{{var("ring")}}'


