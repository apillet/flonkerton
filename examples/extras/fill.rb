module FillScreen
  def fill(color = 0xffffffff)
    @game.draw_quad(0, 0, color, width, 0, color, 0, height, color, width, height, color)
  end
end
