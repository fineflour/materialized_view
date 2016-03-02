# This model is used for address validation
class Address
  STATE_LIST =[["Alabama","AL"],["Alaska","AK"],["American Samoa","AS"],["Arizona","AZ"],["Arkansas","AR"],["California","CA"],["Colorado","CO"],["Connecticut","CT"],["Delaware","DE"],["District of Columbia","DC"],["Florida","FL"],["Georgia","GA"],["Guam","GU"],["Hawaii","HI"],["Idaho","ID"],["Illinois","IL"],["Indiana","IN"],["Iowa","IA"],["Kansas","KS"],["Kentucky","KY"],["Louisiana","LA"],["Maine","ME"],["Marshall Islands","MH"],["Maryland","MD"],["Massachusetts","MA"],["Michigan","MI"],["Minnesota","MN"],["Mississippi","MS"],["Missouri","MO"],["Montana","MT"],["Nebraska","NE"],["Nevada","NV"],["New Hampshire","NH"],["New Jersey","NJ"],["New Mexico","NM"],["New York","NY"],["North Carolina","NC"],["North Dakota","ND"],["Northern Mariana Islands","MP"],["Ohio","OH"],["Oklahoma","OK"],["Oregon","OR"],["Palau","PW"],["Pennsylvania","PA"],["Puerto Rico","PR"],["Rhode Island","RI"],["South Carolina","SC"],["South Dakota","SD"],["Tennessee","TN"],["Texas","TX"],["U.S. Minor Outlying Islands","UM"],["Utah","UT"],["Vermont","VT"],["Virgin Islands","VI"],["Virginia","VA"],["Washington","WA"],["West Virginia","WV"],["Wisconsin","WI"],["Wyoming","WY"],["AA","AA"],["AE","AE"],["AP","AP"]]

  attr_reader :address1, :address2, :city, :state, :zip
  attr_writer :address1, :address2, :city, :state, :zip

  def initialize(*h)
    if h.length == 1 && h.first.kind_of?(Hash)
      h.first.each { |k,v| send("#{k}=",v) }
    end
  end

  def to_s
    "#{self.address1} #{self.address2} \n #{self.city}, #{self.state} #{self.zip}"
  end

  private

end
