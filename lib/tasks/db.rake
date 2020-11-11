namespace :db do
  desc 'Deploys a dump to local DEV environment'
  task :import, [:dump_name] => :environment do |_t, args|
    return if SharedMethods.production_or_admin?

    dump_file = (SharedMethods.verify_dump_name(args.dump_name) || SharedMethods.most_recent_dump_file)

    if dump_file.present?
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d bullpen_development #{dump_file}`
      puts "\n'#{dump_file}' restored to wyzyr_development\n"
    else
      puts 'No database dump file found to import'
    end
  end

  desc 'Makes a dump from your local DEV DB'
  task :export, [:dump_name] => :environment do |_t, args|
    if Rails.env.development?
      backup_filename = (args.dump_name || Time.current.strftime('%Y-%m-%d_development.dump'))
      `pg_dump --verbose -F c -b -h localhost -U postgres -f "#{backup_filename}" bullpen_development`
      puts "\n\n'#{backup_filename}' saved to your hard drive.\n\n"
    else
      puts 'This rake task can only be run on development'
    end
  end
end
