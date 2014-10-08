require 'flipper'
require 'flipper/adapters/activerecord'

adapter = Flipper::Adapters::ActiveRecord.new
$flipper = Flipper.new(adapter)

require 'flipper/middleware/memoizer'
Rails.application.config.middleware.use Flipper::Middleware::Memoizer, $flipper
