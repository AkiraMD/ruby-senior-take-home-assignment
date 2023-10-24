task :default do
  sh 'docker-compose up -d'
end

task :logs do
  sh 'docker-compose logs rest_server'
end

task :restart do
  sh 'docker-compose restart rest_server'
end

task :build do
  sh 'docker-compose build rest_server'
end

task :shutdown do
  sh 'docker-compose down'
end

task :test do |t, args|
  # Additional arguments are passed to rspec. E.g. rake test[-f d] runs the tests with the "documentation" formatter
  sh "docker-compose run --rm -it -e APP_ENV=test --entrypoint \"bundle exec rspec #{args.extras.join(' ')}\" rest_server"
end