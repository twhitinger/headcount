require_relative 'district_repository'
require_relative 'result_set'
require_relative 'result_entry'
require_relative 'math_helper'
class HeadcountAnalyst

  def initialize(district_repo = {})
    @district_repo = district_repo
    @statewide = []
    @passed_average_filter = []
    @passed_lunch_filter = []
    @passed_HS_filter = []
  end

  def kindergarten_participation_rate_variation(location_one, location_two)
    location_one_average =
    compute_kindergartner_participation_average(location_one)
    location_two_average =
    compute_kindergartner_participation_average(location_two[:against])
    MathHelper.truncate_float(location_one_average/location_two_average)
  end

  def compute_kindergartner_participation_average(location_name)
    location = @district_repo.find_by_name(location_name)
    statewide = @district_repo.find_by_name("Colorado")
    loc_avg = location.enrollment.kindergarten_data[:kindergarten_participation].values.reduce(:+)/
    location.enrollment.kindergarten_data[:kindergarten_participation].length
    sw_avg = statewide.enrollment.kindergarten_data[:kindergarten_participation].values.reduce(:+)/
    location.enrollment.kindergarten_data[:kindergarten_participation].length
    loc_avg/sw_avg
  end

  def kindergarten_participation_rate_variation_trend(location_one,
    location_two)
    location1 = @district_repo.find_by_name(location_one)
    loc1 = location1.enrollment.kindergarten_data[:kindergarten_participation]
    location2 = @district_repo.find_by_name(location_two[:against])
    loc2 = location2.enrollment.kindergarten_data[:kindergarten_participation]
    loc1.merge(loc2) { |k, v1, v2| MathHelper.truncate_float(v1/v2) }
  end

  def compute_hs_grad_participation_avg(location_name)
    location = @district_repo.find_by_name(location_name)
    statewide = @district_repo.find_by_name("Colorado")
    loc_avg = location.enrollment.high_school_data[:high_school_graduation_participation].values.reduce(:+)/
    location.enrollment.high_school_data[:high_school_graduation_participation]\
    .length
    sw_avg = statewide.enrollment.high_school_data[:high_school_graduation_participation].values.reduce(:+)/
    location.enrollment.high_school_data[:high_school_graduation_participation]\
    .length
    loc_avg/sw_avg
  end

  def kindergarten_participation_against_high_school_graduation(location_one)
    kg_avg = compute_kindergartner_participation_average(location_one)
    hs_avg = compute_hs_grad_participation_avg(location_one)
    MathHelper.truncate_float(kg_avg/hs_avg)
  end

  def kindergarten_participation_correlates_with_high_school_graduation\
    (location)
    if location[:for] == "STATEWIDE"
      return loop_through_all_schools
    elsif location[:across]
      loop_through_selected_schools(location[:across])
    else
      correlation =
      kindergarten_participation_against_high_school_graduation(location[:for])
      correlation.between?(0.6, 1.5)
    end
  end

  def loop_through_selected_schools(selected_schools)
    array = selected_schools.map do |school|
      kg = compute_kindergartner_participation_average(school)
      hs = compute_hs_grad_participation_avg(school)
      correlation = MathHelper.truncate_float(kg/hs)
      correlation.between?(0.6, 1.5)
    end
    compare_statewide_correlation(array)
  end

  def loop_through_all_schools
    @district_repo.districts.each do |school|
      kg = compute_kindergartner_participation_average(school.name)
      hs = compute_hs_grad_participation_avg(school.name)
      correlation = MathHelper.truncate_float(kg/hs)
      @statewide << correlation.between?(0.6, 1.5)\
      unless school.name == "COLORADO"
      end
      compare_statewide_correlation
    end

    def compare_statewide_correlation(array = @statewide)
      occurances = array.find_all { |correlation| correlation == true }.length
      total = array.length
      (occurances.to_f / total) > 0.7
    end

    def high_poverty_and_high_school_graduation
      average_for_each_district_poverty
      matching_districts = []
      @passed_HS_filter.reduce([]) do |result, school|
        passing_districts = ResultEntry.new({name: school.name, free_and_reduced_price_lunch_rate:
          district_average(school), children_in_poverty_rate: poverty_dist_average(school),
          high_school_graduation_rate: hs_district_average(school)})
          matching_districts << passing_districts
        end
        statewide_result = ResultEntry.new({name: "COLORADO", free_and_reduced_price_lunch_rate:
          average_for_all_districts_qualify_for_free_lunch, children_in_poverty_rate: average_for_all_districts_poverty,
          high_school_graduation_rate: average_for_all_districts_high_school_graduation})
          high_poverty_and_grad_result = ResultSet.new(matching_districts: matching_districts,statewide_average: statewide_result)
        end

        def poverty_dist_average(school)
          average = school.economic_profile.economic_data[:children_in_poverty].values.reduce(:+)/
          school.economic_profile.economic_data[:children_in_poverty].length
        end

        def district_average(school)
          average = school.economic_profile.economic_data[:free_or_reduced_price_lunch]
          each_avg = average.reduce([]) do |result, data|
            result << data.last[:total]
          end
          final_avg = each_avg.reduce(:+)/each_avg.length
        end

        def hs_district_average(school)
          path = school.enrollment.high_school_data[:high_school_graduation_participation].values
          total = path.reduce(:+)
          length = path.length
          total/length
        end


        def average_for_each_district_poverty
          total = @district_repo.districts.find_all do |school|
            school.economic_profile.economic_data[:children_in_poverty]
          end
          total.map do |school|
            average = school.economic_profile.economic_data[:children_in_poverty].values.reduce(:+)/
            school.economic_profile.economic_data[:children_in_poverty].length
            is_it = average > average_for_all_districts_poverty

            # if the district is greater then the average poverty
            # pass it to the next method qualify for free lunch method
            @passed_average_filter << school if is_it
          end
          average_for_each_district_qualify_for_free_lunch(@passed_average_filter)
        end

        def average_for_all_districts_poverty
          total = @district_repo.districts.find_all do |school|
            school.economic_profile.economic_data[:children_in_poverty]
          end
          values = total.reduce([]) do |result, school|
            all_values = school.economic_profile.economic_data[:children_in_poverty].values
            result << all_values
            result
          end.flatten
          average = values.reduce(:+)/values.count
        end

        def average_for_each_district_qualify_for_free_lunch(schools)

          # @passed_average_filter[0]
          total = schools.find_all do |school|
            school.economic_profile.economic_data[:free_or_reduced_price_lunch]
          end
          total.map do |school|
            average = school.economic_profile.economic_data[:free_or_reduced_price_lunch]
            each_avg = average.reduce([]) do |result, data|
              result << data.last[:total]
            end
            final_avg = each_avg.reduce(:+)/each_avg.length
            is_it = final_avg > average_for_all_districts_qualify_for_free_lunch
            @passed_lunch_filter << school if is_it
          end
          average_for_each_district_high_school_graduation(@passed_lunch_filter)
        end

        def average_for_all_districts_qualify_for_free_lunch
          total = @district_repo.districts[0].economic_profile.economic_data[:free_or_reduced_price_lunch].values
          values = total.reduce([]) do |result, data|
            result << data[:total]
            result
          end.flatten
          average = values.reduce(:+)/values.count/@district_repo.districts.length
          # Above the statewide average in number of students qualifying for free and reduced price lunch
        end


        def average_for_each_district_high_school_graduation(schools)
          total = schools.find_all do |school|
            school.enrollment.high_school_data[:high_school_graduation_participation]
          end
          total.map do |school|
            each_avg = school.enrollment.high_school_data[:high_school_graduation_participation].values
            final_avg = each_avg.reduce(:+)/each_avg.length
            is_it = final_avg > average_for_all_districts_high_school_graduation
            @passed_HS_filter << school if is_it
          end
        end

        def average_for_all_districts_high_school_graduation
          path = @district_repo.districts[0].enrollment.high_school_data[:high_school_graduation_participation].values
          total = path.reduce(:+)
          length = path.length
          total/length
        end
      end
