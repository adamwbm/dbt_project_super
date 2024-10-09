with 

source as (
    select * from {{ ref('seed_vendors') }}
)

,transformed as (
    select 
        id as vendor_id,
        title as name,
        to_timestamp(created_at, 'MM/DD/YYYY HH24:MI:SS') as created_at
    from source
)

select * from transformed