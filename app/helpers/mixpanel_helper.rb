module MixpanelHelper
  def product_names_list(products)
    list = ""
    products.each do |p|
      list << "#{ content_tag("div", p.name) }"
    end
    list.html_safe
  end

  def results_table_header(count)
    if count == 1
      "The following order was imported:"
    elsif count == 0
      "#{ content_tag("strong", 'No orders were imported') }".html_safe
    else
      "The following #{ content_tag("strong",count) } orders where imported:".html_safe
    end
  end

  def import_table_header(count)
    if count == 1
      "The following order could not be imported:"
    else
      "The following #{ content_tag("strong",count) } orders could not be imported:".html_safe
    end
  end
end
