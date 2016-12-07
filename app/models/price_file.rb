class PriceFile
	include ActiveModel::Model

	#Spree usa este metodo y si no lo pongo en un modelo sin tabla me rompe las bolas
	def PriceFile.where(val)
	end
end
