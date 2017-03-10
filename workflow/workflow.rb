require_relative 'alfred'
require_relative 'netto'

begin
  workflow = Workflow.new ARGV[0]

  Alfred.out workflow.run

rescue Exception => e
  Alfred.error e.message
end
