class ImageAnnotate
  def initialize(source_image,image_list, caption)
    @caption = caption
    @image_list = image_list
    @source_image = source_image
  end
  
  def apply_template
    caption = @caption
    if caption['background']
      background_caption = Magick::Draw.new
      background_caption.opacity(caption['background_opacity'])
      background_caption.fill(caption['background_color'])
      background_caption.rectangle(0, caption['background_start_y'], @source_image.columns, caption['background_start_y'] + caption['background_height'])
      background_caption.draw(@image_list)
      @image_list.alpha(Magick::ActivateAlphaChannel)
    end

    caption_text = Magick::Draw.new
    caption_text.annotate(@image_list, @source_image.columns, @source_image.rows, @source_image.columns/2 + caption['offset_x'], @source_image.rows/2 + caption['offset_y'], caption['text']) do
      self.gravity = Magick::CenterGravity
      self.pointsize = caption['size']
      self.font_family = caption['font']
      self.font_weight = Magick::BoldWeight
      self.stroke = 'transparent'
      self.fill = caption['color']
      self.stroke = caption['stroke'] || caption['color']
      self.stroke_width = caption['stroke_width'] || 1
      self.font_weight = Magick::BoldWeight
      # self.rotation = 270
      self.kerning = 1
      self.interline_spacing = caption['line_spacing'] || 5
      self.align = CenterAlign
    end
    @image_list
  end
end