# TODO: remove this override, temporary until this issue is fixed:
# https://github.com/rails/rails/issues/17195
ENV['QUE_QUEUE'] ||= 'default'

# use async mode so we don't need to run separate worker processes
unless Rails.env.test?
  Que.mode = :async
end

# only sleep workers for 2 seconds instead of default 5
Que.wake_interval = 2
