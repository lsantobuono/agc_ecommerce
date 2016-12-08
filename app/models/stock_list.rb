class StockList
	include ActiveModel::Model

	#Spree usa este metodo y si no lo pongo en un modelo sin tabla me rompe las bolas
	def StockList.where(val)
	end
end
