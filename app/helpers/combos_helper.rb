module CombosHelper
  def object_url(combo)
    admin_combo_url(combo)
  end

  def edit_object_url(combo)
    admin_combo_url(combo)
  end

  def collection_url
    admin_combos_url
  end
end
