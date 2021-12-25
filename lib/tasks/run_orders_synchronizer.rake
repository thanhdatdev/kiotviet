desc 'Orders synchronizer....'
namespace :synchronizers do
  task orders_synchronizer: :environment do
    OrdersSynchronizerWorker.perform_async
    puts 'Orders Synchronizer Successfully'
  end
end
