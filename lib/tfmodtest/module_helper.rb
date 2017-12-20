require 'socket'
require 'yaml'

require 'tfmodtest'

TMT = TFModTest

HOSTNAME = Socket.gethostname
DATE = Time.new.strftime('%y%m%d%H%M%S')
DEFAULT_PREFIX = "TMT#{HOSTNAME}#{DATE}".freeze

module TFModTest
  class ModuleHelper
    include Rake::DSL if defined? Rake::DSL

    class << self
      def install_tasks
        new.install
      end
    end

    def install
      task default: [:preflight]

      def run_task(task_name)
        TMT::ModuleTestRepository.each do |m|
          m.run_task(task_name)
        end
      end

      desc 'Runs all the tests'
      task :preflight do
        run_task('preflight')
      end

      desc 'Destroy any remaining infrastructure'
      task :destroy do
        run_task('destroy')
      end

      desc 'Cleans up the project (after destroying infrastructure)'
      task :clean do
        run_task('clean')
      end
    end
  end
end
