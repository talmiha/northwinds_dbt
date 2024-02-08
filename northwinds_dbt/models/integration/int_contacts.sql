{% set sources = ["stg_hubspot_contacts", "stg_rds_customers"] %}

  with merged_contacts as (
    {% for source in sources %}
        select first_name, {{ 'contact_id' if 'hubspot' in source else 'null' }} as hubspot_contact_id,
        {{ 'customer_id' if 'rds' in source else 'null' }} as rds_contact_id
         from {{ ref(source) }}
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
  ), 
    deduped as (
    select max(hubspot_contact_id) as hubspot_contact_id, 
    max(rds_contact_id) as rds_contact_id, first_name from merged_contacts group by first_name
  )
  select {{ dbt_utils.generate_surrogate_key(['deduped.first_name']) }} as company_pk, hubspot_contact_id, rds_contact_id, deduped.first_name
  from deduped
  join {{ ref('stg_rds_customers') }} rds_companies on rds_companies.company_id = deduped.rds_contact_id
