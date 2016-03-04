class OrderSearch

  # using KeywordSearch gem to extract options from the query string
  attr_reader :searchterms, :after, :before, :has_exception

  def initialize(querystring)
    @querystring = querystring || ''
    parse_keywords
  end


  def parse_keywords
    KeywordSearch.search(@querystring) do |with|
      with.default_keyword :searchterms

      with.keyword :searchterms do |values|
        @searchterms = values.join(' ')
      end

      with.keyword :before do |values|
        begin
          date = Date.parse(values.first, true) # only one date
        rescue
          @before = nil
        else
          @before = date
        end
      end

      with.keyword :in_state do |values|
        begin
        rescue
          @in_state = nil
        else
          @in_state = values
        end
      end

      with.keyword :after do |values|
        begin
          date = Date.parse(values.first) # only one date
        rescue
          @after = nil
        else
          @after = date
        end
      end

      with.keyword :has do |values|
        @has_exception = true if values.include?('exception')
      end

      #with.keyword :product do |values|
      #  @productname = values
      #end

      with.keyword :id do |values|
        @id = values.first.to_i
      end

      with.keyword :language_spoken do |values|
        @language_spoken = values.first.capitalize
      end

      with.keyword :product_language do |values|
        @product_language = values.first.capitalize
      end

      with.keyword :city do |values|
        @cities = values
      end

      with.keyword :state do |values|
        @states = values
      end
    end
  end

  def result
    #binding.pry
    orders = OrderSearchMatview.unscoped.all #.includes(:products)
    orders = OrderSearchMatview.pgsearch(@searchterms) if @searchterms

    #orders = Order.unscoped.all #.includes(:products)
    #orders = Order.pgsearch(@searchterms) if @searchterms
    #orders = orders.by_orderproduct_state(@in_state) if @in_state

    #orders = orders.after(@after) if @after
    #orders = orders.before(@before) if @before
    #orders = orders.with_exception if @has_exception
    #orders = orders.where(id: @id) if @id
    #orders = orders.limit(100)
    #orders = orders.where(language_spoken: @language_spoken) if @language_spoken
    #orders = orders.joins(:products).where(products: { language: @product_language}).uniq if @product_language

    #orders = orders.where(city: @cities) if @cities
    #orders = orders.where(state: @states) if @states

    #orders.order("orders.created_at desc")
  end


end
