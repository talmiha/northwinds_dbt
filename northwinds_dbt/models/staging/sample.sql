
{% for i in range(6) %}
  {% if i % 2 == 0: %}
    {% set value = ' fizz' %}
  {% else: %}
    {% set value = ' buzz' %}
  {% endif %}
  select {{ i }} as number, {{ value }} as output {% if not loop.last %} union all {% endif%}
{% endfor %}