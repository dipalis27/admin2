module BxBlockAdmin
  module V1
    class LocationsController < ApplicationController
      
      def countries
        countries = BxBlockOrderManagement::Country.order('name ASC')
        render json: BxBlockAdmin::CountrySerializer.new(countries).serializable_hash, status: :ok
      end

      def states
        country = BxBlockOrderManagement::Country.find_by(id: params[:country_id])
        if country
          address_states = country.address_states.order('name ASC')
          render json: BxBlockAdmin::AddressStateSerializer.new(address_states).serializable_hash, status: :ok
        else
          render json: {errors: [{message: "Country Not Found"},
          ]}, status: :unprocessable_entity
        end
      end

      def cities
        address_state = BxBlockOrderManagement::AddressState.find_by(id: params[:state_id])
        if address_state
          if params[:term].present? 
            cities = address_state.cities.where('lower(name) like ?', "%#{params[:term].to_s.downcase}%")
          else
            cities = address_state.cities.order('name ASC')
          end
          render json: BxBlockAdmin::CitySerializer.new(cities).serializable_hash, status: :ok
        else
          render json: {errors: [{message: "State Not Found"},
          ]}, status: :unprocessable_entity
        end
      end
    end
  end
end