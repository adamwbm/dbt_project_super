with 

order_line_items as (
    select 
        order_line_item_id,
        order_id,
        product_id,
        quantity,
        total_price
    from {{ ref('stg_order_line_items') }}
)

select * from order_line_items