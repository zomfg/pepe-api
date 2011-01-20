class ApiController < ApplicationController
  respond_to :html, :xml, :json

  def initialize
    @kym_client = KymClient.new
  end
end
