WITH source AS (
    SELECT * 
    FROM {{ source('intercom', 'conversation_parts') }}
)

SELECT
    
    DISTINCT

    --CONVERSATION
    conversation_id,

    --CONVERSATION PARTS
    id as conversation_part_id,
    part_group as conversation_part_group,
    type as conversation_part_type,
    
    created_at as conversation_part_created_at,
    created_at::date as conversation_part_created_on,
    notified_at as conversation_part_notified_at,
    notified_at as conversation_part_notified_on,
    updated_at as conversation_part_updated_at,
    updated_at::date as conversation_part_updated_on,

    --ASSIGNEE
    json_extract_path_text(replace(replace(assigned_to, 'None', 'null'),'''','"')::variant,'id') as conversation_part_assigned_to_id,
    json_extract_path_text(replace(replace(assigned_to, 'None', 'null'),'''','"')::variant,'type') as conversation_part_assigned_to_type,

    --AUTHOR
    json_extract_path_text(author, 'id') as conversation_part_author_id,
    json_extract_path_text(author, 'type')::string as conversation_part_author_type

FROM
  source
