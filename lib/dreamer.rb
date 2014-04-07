require 'sqlite3'

module DMR
end

require_relative "dreamer/user.rb"
require_relative "dreamer/journal_entry.rb"
require_relative "dreamer/db.rb"
require_relative "dreamer/sleep_entry.rb"
require_relative "dreamer/session.rb"
require_relative "use_case.rb"
Dir[File.dirname(__FILE__) + '/use_case/*.rb'].each {|file| require_relative file }


require 'pry-debugger'
