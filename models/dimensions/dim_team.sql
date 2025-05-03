SELECT * 
FROM (VALUES
    (5217337, 'Héloïse', 'Support'),
    (5391224, 'Justine', 'Support'),
    (5440474, 'Patrick', 'Support'),
    (5300290, 'Raphael', 'Support')
) AS agents (assignee_id, assignee_name, assignee_team)
