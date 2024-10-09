with

products as (
    select 
        product_id,
        name,
        price,
        cost,
        vendor_id,
        created_at
    from {{ ref('stg_products') }}
)

select * from products