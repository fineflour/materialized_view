desc 'Update the Sales materialized view'
task :update_order_search_matview => :environment do
    OrderSearchMatview.refresh
end
