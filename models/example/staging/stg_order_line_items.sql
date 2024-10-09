with 

source as (
    select * from {{ ref('seed_order_line_items') }}
)

,transformed as (
    select 
        id as order_line_item_id,
        order_id,
        product_id,
        quantity,
        total_price
    from source
)

select * from transformed