desc 'Compile site'
task :compile do
    require 'nanoc'
    require 'nanoc/cli'

    Dir.chdir('web')
    Nanoc::CLI.run({})
end

task :default => :compile
