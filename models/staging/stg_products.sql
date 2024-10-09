with 

source as (
    select * from {{ ref('seed_products') }}
)

,transformed as (
    select 
        product as product_id,
        title as name,
        category as category_id,
        price,
        cost,
        vendor as vendor_id,
        to_timestamp(created_at, 'MM/DD/YYYY HH24:MI:SS') as created_at
    from source
)

select * from transformed