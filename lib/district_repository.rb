class DistrictRepository

  def find_by_name
    #  returns either nil or an instance of District having done a case insensitive search
  end

  def find_all_matching
    # returns either [] or one or more matches which contain the supplied name fragment, case insensitive
  end

  def load_data(data)
    # return hash {  :enrollment => {
    #   :kindergarten => "./data/Kindergartners in full-day program.csv"
    # }
  end

end
