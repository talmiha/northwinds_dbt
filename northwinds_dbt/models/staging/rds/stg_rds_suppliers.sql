WITH transformed_suppliers as (
  select supplier_id, lower(company_name), contact_name from "northwinds"."public"."suppliers"
)

SELECT * FROM transformed_suppliers