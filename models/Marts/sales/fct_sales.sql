version: 2

models:
  - name: fct_sales
    columns:
      - name: order_date
        tests:
          - not_null
      - name: total_sales
        tests:
          - not_null