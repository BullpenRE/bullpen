# frozen_string_literal: true

module Test
  class FactoriesController < ActionController::Base
    def create
      factory = FactoryBot.create(factory_name, *traits, factory_attributes)
      render json: factory
    end

    private

    def traits
      return unless params[:traits].present?
        params[:traits].map { |_key, trait| trait.to_sym }
    end

    def factory_name
      params.fetch(:name)
    end

    def factory_attributes
      params.fetch(:attributes).permit!.to_h
    end
  end
end
