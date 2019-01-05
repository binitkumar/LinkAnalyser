json.extract! message, :id, :link, :title, :content, :created_at, :updated_at
json.url message_url(message, format: :json)
