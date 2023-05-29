SELECT
  c.contact_id,
  c.username,
  m.message_content,
  m.timestamp
FROM
  Contacts AS c
  JOIN Messages AS m ON (
    m.sender_id = c.contact_id
    OR m.recipient_id = c.contact_id
  )
WHERE
  m.timestamp = (
    SELECT
      MAX(timestamp)
    FROM
      Messages
    WHERE
      (
        sender_id = c.contact_id
        OR recipient_id = c.contact_id
      )
  )
ORDER BY
  m.timestamp DESC;