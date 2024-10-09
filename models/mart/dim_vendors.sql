with

vendors as (
    select 
        vendor_id,
        name,
        created_at
    from {{ ref('stg_vendors') }}
)

select * from vendors