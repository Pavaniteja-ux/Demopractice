select
    customer_key,
    customer_id,
    customer_name,
    city,
    state_province,
    country_region,
    postal_code
from {{ ref('stg_customerdata') }}