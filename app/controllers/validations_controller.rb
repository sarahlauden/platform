require 'data_validator'

class ValidationsController < ApplicationController
  # GET /validations
  # GET /validations.json
  def index
  end

  # GET /validations/report
  # GET /validations/report.json
  def report
    @report = DataValidator.new.report
  end
end
