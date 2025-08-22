class LandingController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @foods = Food.with_attached_image
  end
end
