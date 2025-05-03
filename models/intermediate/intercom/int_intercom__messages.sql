WITH stg_intercom__conversation_parts AS (
  SELECT * FROM {{ ref('stg_intercom__conversation_parts') }}
)

SELECT

  conversation_id,

  --VOLUME
  COUNT(DISTINCT conversation_part_id) as nb_messages_not_bot,

  --FIRST MESSAGE
  MIN(CASE WHEN conversation_part_author_type = 'user' THEN conversation_part_created_at END) AS first_message_created_at,
  DECODE(EXTRACT(dayofweek FROM first_message_created_at),
      1, 'Monday',
      2, 'Tuesday',
      3, 'Wednesday',
      4, 'Thursday',
      5, 'Friday',
      6, 'Saturday',
      7, 'Sunday') AS first_message_creation_day,
  EXTRACT(HOUR FROM first_message_created_at) AS first_message_creation_hour,
  CASE WHEN first_message_creation_hour <= 13 THEN 'Morning' ELSE 'Afternoon' END AS first_message_creation_time,
  CONCAT(first_message_creation_day,' ',first_message_creation_time) AS first_message_creation_daytime,
  
  --TIME TO ANSWER
  MIN(CASE WHEN conversation_part_author_type = 'admin' THEN conversation_part_created_at END) AS first_answer_created_at,
  DATEDIFF('minute',first_message_created_at,first_answer_created_at) AS time_to_answer_minutes,
  CASE WHEN time_to_answer_minutes <=5 THEN true ELSE false END AS sla_time_to_answer_met

FROM stg_intercom__conversation_parts

WHERE conversation_part_group = 'Message' and conversation_part_author_type <> 'bot'

GROUP BY conversation_id
