json.extract! enrollment, :id, :progress, :user_id, :course_id, :created_at, :updated_at
json.url enrollment_url(enrollment, format: :json)
