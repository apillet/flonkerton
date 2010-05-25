module InputHandler
  def input
    @input ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def pressed?(key)
    input[key].detect { |k| @game.button_down?(k) }
  end
end
