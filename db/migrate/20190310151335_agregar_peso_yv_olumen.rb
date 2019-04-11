class AgregarPesoYvOlumen < ActiveRecord::Migration
  def change
    if Spree::Product.any?
      botones = Spree::Product.in_taxon(Spree::Taxon.find_by(name: "BOTONES"))
      palancas = Spree::Product.in_taxon(Spree::Taxon.find_by(name: "PALANCAS"))
      interfaces = Spree::Product.in_taxon(Spree::Taxon.find_by(name: "INTERFACES"))
      cableados = Spree::Product.in_taxon(Spree::Taxon.find_by(name: "CABLEADOS"))
      
      manoplas = Spree::Product.in_taxon(Spree::Taxon.find_by(name: "MANOPLAS GRANDES"))
      minidiscos = Spree::Product.in_taxon(Spree::Taxon.find_by(name: "MINIDISCOS"))

      portaplaqueta_1 = Spree::Product.find_by(name: "PORTA PLAQUETA - 1 patita sola")
      portaplaqueta_2 = Spree::Product.find_by(name: "PORTA PLAQUETA Juego de 2 unidades")
      portaplaqueta_4 = Spree::Product.find_by(name: "PORTA PLAQUETA Juego de 4 unidades")

      pelotita_1 = Spree::Product.find_by(name: "PELOTITAS DE MADERA")
      pelotita_gajo = Spree::Product.find_by(name: "PELOTITAS GAJO")
      pelotita_500 = Spree::Product.find_by(name: "PELOTITAS de Metegol LISAS x 500uds")


      if botones.any?
        botones.each do |b|
          b.volume = 115.2
          b.weight = 27.2
          b.restrictive_measure = 0
          b.save
        end
      end

      if palancas.any?
        palancas.each do |p|
          p.volume = 864
          p.weight = 363
          p.restrictive_measure = 0
          p.save
        end
      end

      if interfaces.any?
        interfaces.each do |i|
          i.volume = 624
          i.weight = 108
          i.restrictive_measure = 0
          i.save
        end
      end

      if manoplas.any?
        manoplas.each do |m|
          m.volume = 482
          m.weight = 104
          m.restrictive_measure = 0
          m.save
        end
      end

      if minidiscos.any?
        minidiscos.each do |m|
          m.volume = 25
          m.weight = 6.6
          m.restrictive_measure = 0
          m.save
        end
      end

      if portaplaqueta_1.present?
        portaplaqueta_1.volume = 17
        portaplaqueta_1.weight = 7
        portaplaqueta_1.restrictive_measure = 0
        portaplaqueta_1.save
      end

      if portaplaqueta_2.present?
        portaplaqueta_2.volume = 17*2
        portaplaqueta_2.weight = 7*2
        portaplaqueta_2.restrictive_measure = 0
        portaplaqueta_2.save
      end

      if portaplaqueta_4.present?
        portaplaqueta_4.volume = 17*4
        portaplaqueta_4.weight = 7*4
        portaplaqueta_4.restrictive_measure = 0
        portaplaqueta_4.save
      end

      if pelotita_1.present?
        pelotita_1.volume = 56
        pelotita_1.weight = 21.1
        pelotita_1.restrictive_measure = 0
        pelotita_1.save
      end

      if pelotita_gajo.present?
        pelotita_gajo.volume = 56
        pelotita_gajo.weight = 21.1
        pelotita_gajo.restrictive_measure = 0
        pelotita_gajo.save
      end

      if pelotita_500.present?
        pelotita_500.volume = 56 * 500
        pelotita_500.weight = 21.1 * 500
        pelotita_500.restrictive_measure = 0
        pelotita_500.save
      end
    end

  end
end
