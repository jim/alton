Alton::Unit.define do

  unit(:teaspoon) do
    abbreviated 't', :case_sensitive => true
    abbreviated 'tsp'
    volume '1/6', :fl_oz
    volume 4.93, :ml
  end
  
  unit :tablespoon do
    abbreviated 'T', :case_sensitive => true
    abbreviated 'tbs'
    abbreviated 'tbsp'
    volume '1/2', :fl_oz
    volume 14.79, :ml
  end
  
  unit :cup do
    abbreviated 'c'
    abbreviated 'C'
    volume 8, :fl_oz
    volume 236.59, :ml
  end
  
  unit :pint do
    abbreviated 'pt'
    volume 16, :fl_oz
    volume 473.18, :ml
  end
  
  unit :quart do
    abbreviated 'qt'
    volume 32, :fl_oz
    volume 946.35, :ml
  end
  
  unit :gallon do
    volume 128, :fl_oz
    volume 3785.41, :ml
  end

  unit :pound do
    abbreviated 'lb'
    weight 16, :oz
  end

  unit :clove
  
  # Whole apple, half a pizza, etc.
  unit :object

end