Rake::Task["assets:precompile"].enhance do
  Rake::Task["salescamp:create_non_digest_client_js"].invoke
  Rake::Task["salescamp:create_non_digest_salescamp_store_js"].invoke
end

namespace :salescamp do
  logger = Logger.new($stderr)
  # Based on suggestion at https://github.com/rails/sprockets-rails/issues/49#issuecomment-20535134
  task :create_non_digest_client_js => :"assets:environment"  do
    manifest_path = Dir.glob(File.join(Rails.root, 'public/assets/.sprockets-manifest-*.json')).first
    manifest_data = JSON.load(File.new(manifest_path))

    digested_path = manifest_data["assets"]['salescamp_client.js']
    full_digested_path    = File.join(Rails.root, 'public/assets', digested_path)
    full_nondigested_path = File.join(Rails.root, 'public', 'salescamp.js')
    logger.info "salescamp_client Copying to #{full_nondigested_path}"

    FileUtils.copy_file full_digested_path, full_nondigested_path, true
  end

  task :create_non_digest_salescamp_store_js => :"assets:environment"  do
    manifest_path = Dir.glob(File.join(Rails.root, 'public/assets/.sprockets-manifest-*.json')).first
    manifest_data = JSON.load(File.new(manifest_path))

    digested_path = manifest_data["assets"]['salescamp_store.js']
    full_digested_path    = File.join(Rails.root, 'public/assets', digested_path)
    full_nondigested_path = File.join(Rails.root, 'public', 'salescamp_store.js')
    logger.info "salescamp_store Copying to #{full_nondigested_path}"

    FileUtils.copy_file full_digested_path, full_nondigested_path, true
  end

end
