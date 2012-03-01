class RecordsController < ApplicationController
  def show
    @record = Record.current
    fresh_when @record
  end
end
