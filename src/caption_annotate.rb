class CaptionAnnotate

  # TODO Auto create new lines based on word count appropriate for each line

  def apply_template
    canvas = Magick::Image.new(800, 600) do |c|
      c.background_color = 'rgba(23,168,230,0.9)'
    end

    center_caption = Draw.new
    center_caption.annotate(canvas, 0, 0, 0, 0, "VIRAT KOHLI'S 169\n IS HIS HIGHEST SCORE\nIN TEST MATCHES.") do
      self.gravity = Magick::CenterGravity
      self.font_weight = Magick::BoldWeight
      self.kerning = 1
      self.pointsize = 60
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

    output = '/Users/leninraj/Documents/8dict.jpg'
    puts "Writing to #{output}"
    canvas.write(output)
    output
  end
end