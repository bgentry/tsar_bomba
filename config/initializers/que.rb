# TODO: remove this override, temporary until this issue is fixed:
# https://github.com/rails/rails/issues/17195
ENV['QUE_QUEUE'] ||= 'default'

if Rails.env.development?
  # quiet down Que in dev environments
  Rails.application.config.que.worker_count  = 1
  Rails.application.config.que.wake_interval = 10
else
  # only sleep workers for 2 seconds instead of default 5
  Rails.application.config.que.wake_interval = 2
end
