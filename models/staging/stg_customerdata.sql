with src as (
    select
        customerkey,
        customer_id       as customer_id_raw,
        customer          as customer_name_raw,
        city              as city_raw,
        state_province    as state_province_raw,
        country_region    as country_region_raw,
        postal_code       as postal_code_raw
    from {{ source('raw', 'customerdata') }}
),
cleaned as (
    select
        try_to_number(customerkey)        as customer_key,
        nullif(trim(customer_id_raw), '') as customer_id,
        initcap(trim(customer_name_raw))  as customer_name,
        initcap(trim(city_raw))           as city,
        initcap(trim(state_province_raw)) as state_province,
        initcap(trim(country_region_raw)) as country_region,
        trim(postal_code_raw)             as postal_code
    from src
    where coalesce(upper(trim(customer_name_raw)), '') <> '[NOT APPLICABLE]'
      and try_to_number(customerkey) is not null
),
dedup as (
    select *
    from cleaned
    qualify row_number() over (partition by customer_key order by customer_id) = 1
)
select *
from dedup