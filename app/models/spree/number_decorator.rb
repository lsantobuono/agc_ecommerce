module Spree
  module Core
    NumberGenerator.class_eval  do
      
      STARTING_NUMBER = 1

      private 

        def new_candidate(length, host = nil)
          if (host != nil)
            max_number = host.maximum(:number) || STARTING_NUMBER
          else
            return (@prefix + length.times.map { @candidates.sample(random: @random) }.join)
          end
          
          if (host == Spree::Order) # Porque hay ordenes con R y no quiero cambiarlas porque puedo bardear hago esto
            #para buscar el maximo numero con P en ordenes, que es el nuevo prefijo... Eventualmente podrian volarse todos los numeros con R
            # y quitar esto
            max_number = host.where("number like '#{@prefix}00%'").maximum(:number) || STARTING_NUMBER 
          end
          numero = (max_number.gsub(@prefix, '').to_i + 1).to_s
          @prefix + "0"*(length-numero.length) + (max_number.gsub(@prefix, '').to_i + 1).to_s
        end

        def generate_permalink(host)
          length = @length

          loop do
            candidate = new_candidate(length, host)
            return candidate unless host.exists?(number: candidate)
            # If over half of all possible options are taken add another digit.
            length += 1 if host.count > Rational(Spree::BASE**length, 2)
          end
        end
    
    end
  end
end
