WITH stg_intercom__conversations AS (
  SELECT * FROM {{ ref('stg_intercom__conversations') }}
)

SELECT

    DISTINCT

    --CONVERSATION
    conversation_id,

    conversation_is_open,
    conversation_priority,
    conversation_is_read,
    conversation_state,
    conversation_type,

    conversation_created_at,
    conversation_created_on,
    conversation_updated_at,
    conversation_updated_on,

    conversation_waiting_since,

    --ASSIGNEE
    conversation_assignee_id,
    conversation_assignee_type,

    --CSAT
    conversation_csat,
    conversation_csat_created_at,
    conversation_csat_created_on,
    conversation_csat_remark,
    conversation_csat_teammate_id,
    conversation_csat_teammate_type,
    is_csat_rated,
    has_csat_remark,

    --TAGS
    LISTAGG(conversation_tags_name,', ') AS conversation_tag_list

FROM stg_intercom__conversations

GROUP BY all
