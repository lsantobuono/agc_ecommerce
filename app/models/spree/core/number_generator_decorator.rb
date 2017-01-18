module Spree
  module Core
    NumberGenerator.class_eval  do
      
      STARTING_NUMBER = 1

      def new_candidate(host)
        max_number = host.maximum(:number) || STARTING_NUMBER
        
        if (host == Spree::Order) # Porque hay ordenes con R y no quiero cambiarlas porque puedo bardear hago esto
          #para buscar el maximo numero con P en ordenes, que es el nuevo prefijo... Eventualmente podrian volarse todos los numeros con R
          # y quitar esto
          max_number = host.where("number like '#{@prefix}%'").maximum(:number) || STARTING_NUMBER 
        end

        @prefix + (max_number.gsub(@prefix, '').to_i + 1).to_s
      end

      def generate_permalink(host)
        loop do
          candidate = new_candidate(host)
          return candidate unless host.exists?(number: candidate)

          # If over half of all possible options are taken add another digit.
          length += 1 if host.count > Rational(BASE**length, 2)
        end

        
      end
    
    end
  end
end
