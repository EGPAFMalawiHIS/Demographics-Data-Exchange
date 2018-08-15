class Api::V1::NpidController < ApplicationController
  def assign_npids
    npids = NpidService.assign(params[:limit], current_user)
    render json: npids
  end
end
