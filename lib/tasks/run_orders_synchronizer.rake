desc 'Orders synchronizer....'
namespace :synchronizers do
  task orders_synchronizer: :environment do
    Synchronizers::OrdersSynchronizer.call
    puts 'Orders Synchronizer Successfully'
  end
end
