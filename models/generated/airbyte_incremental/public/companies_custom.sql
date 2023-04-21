{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "public",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('companies_custom_ab2') }}
select distinct on (_airbyte_unique_key)
    _airbyte_unique_key,
    _airbyte_companies_hashid,
    updatedAt,
    companyId,
    name,
    type,
    value,
    fieldid,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('companies_custom_ab2') }}
-- custom at companies/custom from {{ ref('companies_scd') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}
order by _airbyte_unique_key, fieldId, _airbyte_emitted_at desc