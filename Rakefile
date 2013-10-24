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
    Dir.mktmpdir do |dir|
        hash = `git show-ref --hash HEAD`.strip
        puts "Publishing revision #{hash}"

        puts 'Fetching current state from origin'
        `git fetch origin gh-pages`
        `git update-ref refs/heads/gh-pages FETCH_HEAD`

        `git clone --branch gh-pages --single-branch . #{dir}`

        # Copy all output files to a temporary directory
        with_environment 'GIT_DIR' => "#{dir}/.git", 'GIT_WORK_TREE' => dir do
            # Reset the branch with the latest build output
            `git rm -rf #{dir}/*`
            `cp -r ./web/output/* #{dir}`

            # Add CNAME for subdomain alias
            File.open("#{dir}/CNAME", 'w') {|f| f.write('michael.mior.ca') }

            `git add #{dir}`
            `git config user.name '#{ENV['GIT_NAME']}'` if !ENV['GIT_NAME'].nil?
            `git config user.email '#{ENV['GIT_EMAIL']}'` if !ENV['GIT_EMAIL'].nil?
            `git commit -m 'Publish of revision #{hash}'`
            puts `git log -1`

            # Push back to the local repo (not GitHub)
            `git push origin gh-pages`
        end
    end
end

desc 'Push gh-pages branch to GitHub'
task :deploy => :publish do
    if ENV['GH_TOKEN'].nil?
      `git push origin gh-pages`
    else
      `git push https://#{ENV['GH_TOKEN']}:@github.com/michaelmior/michael.mior.ca.git gh-pages 2>&1 | grep -v https`
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
