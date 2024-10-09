with 

order_line_items as (
	select * from {{ ref('fct_order_line_item_enriched') }}
)

,orders_month as (
	select 
		order_id,
		customer_id,
		order_year,
		order_month,
		sum(quantity) as basket_size,
		max(total_order_price) as total_order_price
	from order_line_items
	where refunded_at is null
	group by 1,2,3,4
)

,final as (
	select 
		order_year,
		order_month,
		round(avg(basket_size::decimal),2) as avg_basket_size,
		round(avg(total_order_price::decimal),2) as avg_order_price,
		sum(total_order_price) as gmv,
		count(distinct customer_id) as active_customers
	from orders_month
	group by 1,2
	order by 1,2
)

select * from final