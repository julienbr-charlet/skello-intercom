WITH stg_intercom__conversations AS (
  SELECT * FROM {{ ref('stg_intercom__conversations') }}
),

int_intercom__messages AS (
  SELECT * FROM {{ ref('int_intercom__messages') }}
),

dim_team AS (
  SELECT * FROM {{ ref('dim_team') }}
)

SELECT

  c.*,
  t.assignee_name,
  m.*

FROM stg_intercom__conversations c

LEFT JOIN int_intercom__messages m USING (conversation_id)
LEFT JOIN dim_team t ON c.conversation_assignee_id = t.assignee_id

WHERE t.assignee_team = 'Support'
