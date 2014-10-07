# TODO: remove this override, temporary until this issue is fixed:
# https://github.com/rails/rails/issues/17195
ENV['QUE_QUEUE'] ||= 'default'

# only sleep workers for 2 seconds instead of default 5
Que.wake_interval = 2
