#!/usr/bin/env ruby

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'rspec'
  gem 'sqlite3'
end

require 'csv'
require 'sqlite3'

DB = SQLite3::Database.new 'slcsp.sqlite3'

# Given a zipcode which has at least 2 silver prices, returns the second lowest.
# Otherwise, returns nil.
def slcsp(zip)
  # Distinct cleanly handles multiple entries with same rate issue
  query = "SELECT DISTINCT rate
           FROM plan_zips
           WHERE zipcode = '#{zip}'"
  rates = DB.execute(query).flatten.sort
  # Return nil if less than 2 silver rates for zip
  rates.count > 1 ? rates[1].round(2) : nil
end

def build_csv
  CSV.open("slcsp-out.csv", "w") do |csv_write|
    csv_write << ["zipcode", "rate"] # Manually write header
    csv = CSV.foreach("slcsp.csv", headers: true) do |row|
      price = slcsp(row["zipcode"])
      row["rate"] = sprintf("%.2f", price) if price
      csv_write << row
    end
  end
end

build_csv

###########################################################
#################### SPECS ################################
###########################################################
require 'rspec/autorun'

RSpec.describe '#slcsp' do
  example do
    expect(slcsp("64148")).to be 245.20 # Multiple rates
    expect(slcsp("12961")).to be nil    # No silver rates
    expect(slcsp("28411")).to be 307.51 # Multiple counties
    expect(slcsp("07734")).to be nil    # Single rate, no second lowest
  end
end

