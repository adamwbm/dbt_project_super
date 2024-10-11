with 

order_line_items as (
	select * from {{ ref('fct_order_line_items_enriched') }}
)

,first_order as (
	select
		customer_id,
		min(order_dt) as first_order_dt
	from order_line_items
	group by 1
)

,final as (
	select 
		order_id,
		order_dt,
		first_order_dt,
        date_trunc('month',first_order_dt) + interval '1' day as first_order_month_dt,
		order_year,
		order_month,
		customer_id,
		customer_country,
		customer_state,
		customer_gender,  
        refunded_at,
		extract(month from age(date_trunc('month',order_dt),date_trunc('month',first_order_dt))) as period,
        sum(quantity) as basket_size,
		max(total_order_price) as total_order_price
	from order_line_items lo
	left join first_order fo
	using(customer_id)
	group by 1,2,3,4,5,6,7,8,9,10,11,12
	order by 1
)

select * from final