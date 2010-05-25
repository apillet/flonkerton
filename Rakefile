task :default do
  system %Q(ruby test/unit_tests.rb)
end

task :test do
  system %Q(ruby test/integration_test.rb)
end

task :rcov do
  system %Q(rcov test/unit_tests.rb --exclude gosu,protest,rr,rcov)
end
