WITH source AS (
    SELECT * 
    FROM {{ source('intercom', 'conversations') }}
)

SELECT

    DISTINCT

    --CONVERSATION
    id as conversation_id,

    open as conversation_is_open,
    priority as conversation_priority,
    read as conversation_is_read,
    state as conversation_state,
    type as conversation_type,

    created_at::timestamp as conversation_created_at,
    created_at::date as conversation_created_on,
    updated_at::timestamp as conversation_updated_at,
    updated_at::date as conversation_updated_on,

    waiting_since as conversation_waiting_since,

    --ASSIGNEE
    json_extract_path_text(assignee, 'id')::bigint as conversation_assignee_id,
    json_extract_path_text(assignee, 'type') as conversation_assignee_type,

    --CSAT
    json_extract_path_text(conversation_rating, 'rating')::int as conversation_csat,
    json_extract_path_text(conversation_rating, 'created_at')::timestamp as conversation_csat_created_at,
    conversation_csat_created_at::date as conversation_csat_created_on,
    json_extract_path_text(conversation_rating, 'remark') as conversation_csat_remark,
    json_extract_path_text(json_extract_path_text(conversation_rating, 'teammate'),'id') as conversation_csat_teammate_id,
    json_extract_path_text(json_extract_path_text(conversation_rating, 'teammate'),'type') as conversation_csat_teammate_type,
    case when conversation_csat is null then false else true end as is_csat_rated,
    case when conversation_csat_remark is null then false else true end as has_csat_remark,

    --TAGS
    t_tags.value:"applied_at"::timestamp_ntz as conversation_tags_applied_at,
    conversation_tags_applied_at::date as conversation_tags_applied_on,
    json_extract_path_text(t_tags.value:"applied_by",'id') as conversation_tags_applied_by_id,
    json_extract_path_text(t_tags.value:"applied_by",'type') as conversation_tags_applied_by_admin,
    t_tags.value:"id"::bigint as conversation_tags_id,
    t_tags.value:"name"::string as conversation_tags_name,
    t_tags.value:"type"::string as conversation_tags_type

FROM
  source,
LATERAL FLATTEN(input => tags) as t_tags
