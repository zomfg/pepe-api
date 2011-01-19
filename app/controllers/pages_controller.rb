class PagesController < ApplicationController
  respond_to :html

  def show
    known_pages = ['home', 'about']
    page = 'home'
    page = (params[:page_name].nil? ? 'home' : params[:page_name])
    render :status => :not_found, :text => 'Oops' and return unless known_pages.include?(page)
    render page
  end
end
