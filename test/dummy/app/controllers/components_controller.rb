# frozen_string_literal: true

class ComponentsController < ApplicationController
  COMPONENTS = %w[
    accordion alert avatar badge button button-group card checkbox
    dialog dropdown expander grid heading icon image inline-stack kbd menu
    navigation-menu popcard popover progress-bar select separator
    spinner stack text text-field tooltip typography
  ].freeze

  def index
    @components = COMPONENTS
  end

  def show
    @component = params[:id]
    redirect_to components_path unless @component.in?(COMPONENTS)
  end
end
