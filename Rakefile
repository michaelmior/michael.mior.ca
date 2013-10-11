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

desc 'Publish gh-pages branch'
task :publish => :compile do
    hash = `git show-ref --hash HEAD`
    branch = `git name-rev --name-only HEAD`

    Dir.mktmpdir do |dir|
        `git clone . #{dir}`

        # Copy all output files to a temporary directory
        with_environment 'GIT_DIR' => "#{dir}/.git", 'GIT_WORK_TREE' => dir do
            `git checkout gh-pages`
            `git rm -rf #{dir}/*`
            `cp -r ./web/output/* #{dir}`
            `git add #{dir}`
            `git commit -m 'Publish of revision #{hash}'`
            `git push origin gh-pages`
        end
    end
end

task :default => :test

def with_environment(variables={})
  if block_given?
    old_values = variables.map{ |k,v| [k,ENV[k]] }
    begin
       variables.each{ |k,v| ENV[k] = v }
       result = yield
    ensure
      old_values.each{ |k,v| ENV[k] = v }
    end
    result
  else
    variables.each{ |k,v| ENV[k] = v }
  end
end
