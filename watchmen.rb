default_action { system("ruby test/unit_tests.rb") }
#default_action { system("ruby test/integration_test.rb") }

watch( 'lib/flonkerton.rb' )
watch( 'test/unit_tests.rb' )
watch( 'test/integration_test.rb' )
watch( 'config/defaults.yml' )
