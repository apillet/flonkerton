module MouseBorder
  def border
    40
  end

  def mouse_on_left?
    mouse_x <= border
  end

  def mouse_on_top?
    mouse_y <= border
  end

  def mouse_on_right?
    mouse_x >= width - border
  end

  def mouse_on_bottom?
    mouse_y >= height - border
  end
end
