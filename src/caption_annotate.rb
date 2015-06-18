class CaptionAnnotate

  # TODO Auto create new lines based on word count appropriate for each line

  def apply_template
    canvas = Magick::Image.new(700, 500) do |c|
      c.background_color = 'rgba(23,168,230,0.9)' # blue
      # c.background_color = 'rgba(150,93,14,0.9)' # brown
      # c.background_color = 'rgba(230,150,38,0.9)' # orange
    end

    caption = 'Rahul Dravid will coach India A & India U-19 teams.'
    # puts format_caption(caption,4)
    center_caption = Draw.new
    center_caption.annotate(canvas, 0, 0, 0, 0, format_caption(caption,4, true)) do
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.kerning = 1
      self.pointsize = 50
      # self.font = "whatever.ttf"
      self.interline_spacing = 15
      self.fill = 'white'
      self.stroke = "none"
    end

    center_caption = Draw.new
    center_caption.annotate(canvas, 0, 0, 0, 20, 'Want to write short cricket updates?\nWrite to us at info@duggout.com') do
      self.gravity = Magick::SouthGravity
      self.font_weight = Magick::BoldWeight
      self.kerning = 1
      self.pointsize = 15
      # self.font = "whatever.ttf"
      self.interline_spacing = 5
      self.fill = 'white'
      self.stroke = 'none'
    end

    output = '/Users/leninraj/Downloads/8dict.png'
    puts "Writing to #{output}"
    canvas.write(output)
    output
  end

  def format_caption(caption, break_at = 3, should = true)
    return caption unless should
    caption.split.each_slice(break_at).to_a.each_with_object([]) {|item,acc| acc << item.join(' ')}.join("\n")
  end
end