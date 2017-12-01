module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def sort_link(column, title, element_id)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {column: column, direction: direction}, {id: element_id}
  end
  
end
