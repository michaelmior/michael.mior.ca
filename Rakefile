desc 'Compile site'
task :compile do
    require 'nanoc'
    require 'nanoc/cli'

    Dir.chdir('web') do
        Nanoc::CLI.run([])
    end
end

desc 'Run checks'
task :test => :compile do
    require 'nanoc'
    require 'nanoc/cli'

    Dir.chdir('web') do
        Nanoc::CLI.run(['check', '--deploy', '--verbose'])
    end
end

task :default => :test
