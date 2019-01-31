namespace :deploy do
  desc "Runs test before deploying, can't deploy unless they pass"
  task :run_tests do
    test_log = "log/capistrano.test.log"
    tests = fetch(:tests)
    tests.each do |test|
      puts "--> Running tests: '#{test}', please wait ..."
      # TODO: for now, run without javascript tests b/c we haven't setup the chrome headless browser on AdminServer
      #unless system "bundle exec rspec #{test} > #{test_log} 2>&1"
      unless system "bundle exec rspec #{test} -t ~js > #{test_log} 2>&1"
        puts "--> Tests: '#{test}' failed. Results in: #{test_log} and below:"
        system "cat #{test_log}"
        exit;
      end
      puts "--> '#{test}' passed"
    end
    puts "--> All tests passed"
    system "rm #{test_log}"
  end
end
