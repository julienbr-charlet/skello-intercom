WITH stg_intercom__conversations AS (
  SELECT * FROM {{ ref('stg_intercom__conversations') }}
)

SELECT 

    conversation_id,

    tags_applied_at,
    tags_applied_on,
    tags_applied_by_id,
    tags_applied_by_admin,
    tags_id,
    tags_name,
    tags_type

FROM stg_intercom__conversations
