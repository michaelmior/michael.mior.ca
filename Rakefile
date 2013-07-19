desc 'Compile site'
task :compile do
    require 'nanoc'
    require 'nanoc/cli'

    Dir.chdir('web')
    Nanoc::CLI.run([])
end

desc 'Run checks'
task :test => :compile do
    require 'nanoc'
    require 'nanoc/cli'

    Dir.chdir('web')
    Nanoc::CLI.run(['check', '--deploy'])
end

task :default => :test
