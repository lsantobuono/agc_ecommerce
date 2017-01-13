module Spree
	module FrontendHelper
	    def breadcrumbs(taxon, separator="&nbsp;")
	      return "" if current_page?("/") || taxon.nil?
	      separator = raw(separator)
	      crumbs = [content_tag(:li, content_tag(:span, link_to(content_tag(:span, '<i class="fa fa-home" style="font-size:18px" aria-hidden="true"></i>',{ itemprop: "name"}, false), spree.root_path, itemprop: "url") + separator, itemprop: "item"), itemscope: "itemscope", itemtype: "https://schema.org/ListItem", itemprop: "itemListElement")]
	      if taxon
#	        crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, Spree.t(:products), itemprop: "name"), spree.products_path, itemprop: "url") + separator, itemprop: "item"), itemscope: "itemscope", itemtype: "https://schema.org/ListItem", itemprop: "itemListElement")
	        crumbs << taxon.ancestors.drop(1).collect { |ancestor| content_tag(:li, content_tag(:span, link_to(content_tag(:span, ancestor.name, itemprop: "name"), seo_url(ancestor), itemprop: "url") + separator, itemprop: "item"), itemscope: "itemscope", itemtype: "https://schema.org/ListItem", itemprop: "itemListElement") } unless taxon.ancestors.empty?
	        crumbs << content_tag(:li, content_tag(:span, link_to(content_tag(:span, taxon.name, itemprop: "name") , seo_url(taxon), itemprop: "url"), itemprop: "item"), class: 'active', itemscope: "itemscope", itemtype: "https://schema.org/ListItem", itemprop: "itemListElement")
	      else
	        crumbs << content_tag(:li, content_tag(:span, Spree.t(:products), itemprop: "item"), class: 'active', itemscope: "itemscope", itemtype: "https://schema.org/ListItem", itemprop: "itemListElement")
	      end
	      crumb_list = content_tag(:ol, raw(crumbs.flatten.map{|li| li.mb_chars}.join), class: 'breadcrumb', itemscope: "itemscope", itemtype: "https://schema.org/BreadcrumbList")
	      content_tag(:nav, crumb_list, id: 'breadcrumbs', class: 'col-md-12 nav-breadcrumbs')
	    end

		def link_to_cart(text = nil)
		      text = text ? h(text) : Spree.t('cart')
		      css_class = nil

		      if simple_current_order.nil? or simple_current_order.item_count.zero?
		        text = "<span class='glyphicon glyphicon-shopping-cart'></span> #{text} (#{Spree.t('empty')})"
		        css_class = 'empty'
		      else
		        text = "<span class='glyphicon glyphicon-shopping-cart'></span> #{text} (#{simple_current_order.item_count})"
		        if current_spree_user && current_spree_user.confirmed?
					text +=  "<span class='amount'>#{simple_current_order.display_total.to_html}</span>"
				end
		        css_class = 'full'
		      end

		      link_to text.html_safe, spree.cart_path, class: "cart-info #{css_class}"
		end

#		def taxons_tree(root_taxon, current_taxon, max_level = 1)
#			return '' if max_level < 1 || root_taxon.leaf?
#			content_tag :div, class: 'list-group' do
#				taxons = root_taxon.children.map do |taxon|
#					css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'list-group-item active' : 'list-group-item'
#					if current_taxon.leaf?
#						css_class += ' leaf'
#					end
 #       			link_to(taxon.name, seo_url(taxon), class: css_class) + taxons_tree(taxon, current_taxon, max_level - 1)
  #      		end
	#        	safe_join(taxons, "\n")
	 #       end
      #	end

      	#Magia Negra  . 
		def taxons_tree(root_taxon, current_taxon, max_level = 1, root_id, original_category)
			return '' if max_level < 1 || root_taxon.leaf?
			if original_category == true
				listClass = 'list-group panel-collapse accordion-body collapse in'
			else
				listClass = 'list-group panel-collapse accordion-body collapse'
			end
			content_tag :div, id:root_id, class: listClass, style:"margin-bottom:0" do
				taxons = root_taxon.children.map do |taxon|
					link = seo_url(taxon)
					root_id = (root_id*max_level)+1					
					unless taxon.children.empty?
						link = "##{root_id}"
						content_tag :div, id:"accordion-#{root_id}", class: "" do
							l = link_to(link, class: "list-group-item", data: {toggle: "collapse", parent: "#accordion-#{root_id}" }) do
								content_tag(:div, " ", id:"arrow-icon", class: "fa fa-chevron-down", style:"float:right") +taxon.name
							end
							l + taxons_tree(taxon, current_taxon, max_level - 1,root_id,false)
						end 
					else 
						link_to(link, class: 'list-group-item '){content_tag(:span, " ", class: "glyphicon glyphicon-chevron-right") 
							+ taxon.name} + taxons_tree(taxon, current_taxon, max_level - 1,root_id,false)
					end
				end
				safe_join(taxons, "\n")
			end
			#else
			#	content_tag :div, id:root_id+1, data: {toggle: "colapse", parent: "accordion"},
			#	href:"##{root_id+1}" ,class: 'list-group panel-collapse collapse in' do
			#		taxons = root_taxon.children.map do |taxon|
			#			link = seo_url(taxon)
			#			unless taxon.children.empty?
			#				link = "##{root_id+1}"
			#			end 
			#			link_to(link, class: 'list-group-item'){content_tag(:span, " ", class: "glyphicon glyphicon-chevron-right") 
			#				+ taxon.name} + taxons_tree(taxon, current_taxon, max_level - 1,root_id+1)
			#		end
			#		safe_join(taxons, "\n")
			#	end
			#end
		end
	end
end
#TODO : Monoo0o0o0o0o0 creo que el primer if se empty se puede sacar y se puede hacer andar denttro del do |taxon| como esta abajo
# pero habria que modificar el content_tag original dependiendo de si el taxon tiene hijos  no.wn

#		link_to(seo_url(taxon), class: 'list-group-item'){content_tag(:span, " ", class: "glyphicon glyphicon-chevron-right") 
			#			+ taxon.name} + taxons_tree(taxon, current_taxon, max_level - 1,root_id+1)
