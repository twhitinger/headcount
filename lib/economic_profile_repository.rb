require_relative 'economic_profile'
require_relative "math_helper"
require 'csv'
require 'pry'


class EconomicProfileRepository

  attr_reader :economic_profiles

  def initialize
    @economic_profiles = []
  end

  def find_by_name(location_name)
    economic_profiles.find do |econ_data|
      econ_data.name == location_name.upcase
    end
  end

  def load_data(data_tree)
    generate_repo(format_data(data_tree)).each_value do |value|
      economic_profiles << EconomicProfile.new(value)
    end
  end

  def generate_repo(formatted_data)
    formatted_data.each_with_object({}) do |(symbol_id, location_data), econ_data|
      location_data.each do |name, data|
        if econ_data[name].nil?
          econ_data[name] = {symbol_id => data, :name => name}
        else
          econ_data[name][symbol_id] = data
        end
      end
    end
  end

  def format_data(file_tree)
    file_tree[:economic_profile].map do |symbol_id, filename|
      econ_data_to_hash = CSV.readlines(filename, headers: true, header_converters: :symbol).map(&:to_h)
      file_data = Hash.new({})
      econ_data_grouped_by_location(econ_data_to_hash, symbol_id).each do |name, one_districts_data|
        file_data[symbol_id][name] = one_districts_data
      end
      [symbol_id, file_data[symbol_id]]
    end.to_h
  end

  def econ_data_grouped_by_location(econ_data, symbol_id)
    group_data_by_location(econ_data).each_with_object({}) do |(name, values), one_districts_info|
      delegate_by_symbol_id(name, values, one_districts_info, symbol_id)
    end
  end

  def group_data_by_location(data)
    data.group_by { |row| row[:location].upcase }
  end

  def delegate_by_symbol_id(name, value, econ_data_hash, symbol_id)
    case symbol_id
    when :median_household_income
      income_data(name, value, econ_data_hash)
    when :children_in_poverty
      poor_data(name, value, econ_data_hash)
    when :free_or_reduced_price_lunch
      no_such_thing_as_a_free_lunch(name, value, econ_data_hash)
    when :title_i
      title_data(name, value, econ_data_hash)
    end
  end

  def income_data(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      year_data[row[:timeframe].split('-').map(&:to_i)] = row[:data].to_i
    end
  end

  def poor_data(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      year_data[row[:timeframe].to_i] = row[:data].to_f if row[:dataformat].upcase == "PERCENT"
    end
  end

  def no_such_thing_as_a_free_lunch(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      format_field(year_data, row)
      number_or_percent(year_data, row)
    end
    data[name].each do |year, data_hash|
      clean_data(data_hash[:percentage] = data_hash[:percentage] / 6)
    end
  end

  def title_data(name, value, data)
    data[name] = value.each_with_object({}) do |row, year_data|
      year_data[row[:timeframe].to_i] = row[:data].to_f
    end
  end

  def format_field(year_data, row)
    unless year_data.has_key?(row[:timeframe].to_i)
      year_data[row[:timeframe].to_i] = {:percentage => 0, :total => 0}
    end
  end

  def number_or_percent(year_data, row)
    if row[:dataformat].upcase == "NUMBER"
      year_data[row[:timeframe].to_i][:total] += row[:data].to_i
    elsif row[:dataformat].upcase == "PERCENT"
      year_data[row[:timeframe].to_i][:percentage] += row[:data].to_f
    end
  end

  def clean_data(input)
    input.to_s.gsub!(/[\s]+/,'')
    input = MathHelper.truncate_float(input.to_f) if String === input
    input
  end
end
