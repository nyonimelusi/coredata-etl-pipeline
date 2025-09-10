-- Drop the table if it already exists to ensure a clean run
DROP TABLE IF EXISTS accounts_and_web_events;

-- Create the new table and insert the transformed data
CREATE TABLE accounts_and_web_events AS
SELECT 
    a.id AS account_id,
    a.name AS account_name,
    a.website AS account_website,
    we.occurred_at AS web_event_occurred_at,
    we.channel AS web_event_channel
FROM 
    accounts AS a
JOIN 
    web_events AS we
ON 
    a.id = we.account_id;