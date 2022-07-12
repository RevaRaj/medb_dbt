select call_guid,    
    call_duration as {{var('wrap_stage')}}
    from {{ ref('event_data')}}
    where call_type = '{{var("wrap")}}'