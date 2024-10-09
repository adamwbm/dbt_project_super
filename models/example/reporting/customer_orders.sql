with 

order_line_items as (
	select * from {{ ref('fct_order_line_item_enriched') }}
)

,orders_by_customer_monthly as (
	select 
		order_year,
		order_month,
		customer_id,
		customer_country,
		customer_state,
		customer_gender,  
		max(customer_created_dt) as customer_created_dt,
		min(order_dt) first_order_dt,
		sum(total_order_price_by_product) as customer_ltv
	from {{ ref('fct_order_line_item_enriched') }} lo 
	where refunded_at is null
	--and customer_gender = 'M' filters can be applied here to produce 
	group by 1,2,3,4,5,6
	order by 1,2
)

,new_customers as (
	select 
		order_year,
		order_month,
		customer_id,
		customer_country,
		customer_state,
		customer_gender,  
		case when extract(month from customer_created_dt) = order_month 
				and extract(year from customer_created_dt) = order_year 
			then 1 
			else 0 
			end as new_customer_ind,
		first_order_dt,
		customer_ltv,
		count(customer_id) over (partition by order_year,order_month) as monthly_customer_cnt
	from orders_by_customer_monthly
)


,last_customer_cnt as (
	select
		order_year,
		order_month,
		lag(count(distinct customer_id)) over (partition by order_year order by order_month) as last_month_customer_cnt
	from orders_by_customer_monthly
	group by 1,2

)

,final as (
	select 
	    order_year,
	    order_month,
	    customer_id,
	    customer_country,
	    customer_state,
	    customer_gender,  
	    new_customer_ind,
	    first_order_dt,
	    customer_ltv,
	    monthly_customer_cnt,
	    l.last_month_customer_cnt,
	    sum(new_customer_ind) over (partition by order_year, order_month) as monthly_new_customer_cnt,
	    round((monthly_customer_cnt - sum(new_customer_ind) over (partition by order_year, order_month))/l.last_month_customer_cnt::decimal,2) * 100 as monthly_retention_rate_percent
	from new_customers n
	left join last_customer_cnt l
	using (order_year,order_month)

)

select * from final
