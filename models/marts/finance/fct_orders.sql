with payments as (
        select * from {{ref ('stg_stripe__payments') }}
),

orders as (
        select * from {{ref ('stg_jaffle_shop__orders') }}
),

orders_amount_success as  (
        select
            order_id,
            sum(case when status = 'success' then amount else 0 end) as amount

        from payments
        group by 1
),

final as (
        select 
            o.order_id,
            o.customer_id,
            o.order_date,
            coalesce(oas.amount, 0) as amount

        from orders o
        left join orders_amount_success oas
            using (order_id)

)

select * from final
