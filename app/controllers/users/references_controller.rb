class Users::ReferencesController < ApplicationController
  def show
    @reference = Reference.find_by id: params[:id]
    render 'references/show'
  end
end
