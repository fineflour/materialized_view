class OrderSearchMatview < ActiveRecord::Base
  include PgSearch
  self.table_name = 'order_search_matview'
  self.primary_key =:pg_search_id

  self.per_page = 50 # for will paginate
  pg_search_scope :pgsearch, against: [:search_body]
  
#  has_paper_trail
#  geocoded_by :address_p
  
  scope :before, -> (beforedate) { where("order_search_matviews.created_at < ?", beforedate) }
  scope :after, -> (afterdate) { where("orders_search_matviews.created_at > ?", afterdate) }

  def readonly?
    true
  end

  def address_p
    "#{address1} #{address2} #{city} #{state} #{zip}"
  end

 def self.text_search(query)
    if query
      OrderSearch.new(query).result
    else
      #Order.all
      #Order.all
      OrderSearchMatview.all
    end
 end


  def self.refresh
    ActiveRecord::Base.connection.execute('REFRESH MATERIALIZED VIEW CONCURRENTLY order_search_matview')
  end
  
end
