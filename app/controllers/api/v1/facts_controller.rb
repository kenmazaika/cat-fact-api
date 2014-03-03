class Api::V1::FactsController < ApplicationController
	def index
		facts = Fact.page(params[:page] || 1)
		render :json => {
			:page        => params[:page] || 1,
			:total       => facts.total_count,
			:total_pages => facts.total_pages,
			:facts     => facts 
		}
	end

	def create
		fact = Fact.create(fact_params)
		if fact.valid?
			render :json => fact, :status => :created
		else
			render :json => fact.errors, 
				:status => :unprocessable_entity
		end
	end

	private

	def fact_params
		params.require(:fact).permit(:details)
	end
end
