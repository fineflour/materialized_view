
module NumberHelper

  def formatted_date(date)
    date.strftime("%m/%d/%y") unless date.nil?
  end

  def formatted_time(time)
    time.strftime("%l:%M %p") unless time.nil?
  end

  def formatted_number(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse unless number.nil?
  end
end
