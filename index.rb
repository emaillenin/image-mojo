require 'RMagick'
include Magick

require_relative 'src/template/image_mojo_template'

template = ImageMojoTemplate.new(ARGV[0])

imgl = Magick::ImageList.new

src = Magick::Image.read(template.image['path']).first

puts "#{src.columns}x#{src.rows}"

start_x = template.copyright['x_offset']
start_y = (src.rows/2) - template.copyright['height']
end_x = start_x + template.copyright['width']
end_y = (src.rows/2) + template.copyright['height']

imgl.from_blob(File.open(template.image['path']).read)

gc = Magick::Draw.new

gc.fill_opacity(template.copyright['opacity'])

gc.rectangle(start_x, start_y, end_x, end_y)

gc.font(template.copyright['opacity'])

gc.draw(imgl)

imgl.alpha(Magick::ActivateAlphaChannel)

watermark_text = Magick::Draw.new
watermark_text.annotate(imgl, start_x, start_y, end_x - 5, end_y - 10, template.copyright['text']) do
  self.gravity = Magick::EastGravity
  self.pointsize = 15
  self.font_family = 'Arial'
  self.font_weight = Magick::BoldWeight
  self.stroke = 'transparent'
  self.fill = 'white'
  self.rotation = 270
  self.kerning = 1
  self.align = LeftAlign
end

unless template.caption.nil?
  caption_text = Magick::Draw.new
  caption_text.annotate(imgl, src.columns, src.rows, src.columns/2 + template.caption['offset_x'], src.rows/2 + template.caption['offset_y'], template.caption['text']) do
    self.gravity = Magick::CenterGravity
    self.pointsize = template.caption['size']
    self.font_family = template.caption['font']
    self.font_weight = Magick::BoldWeight
    self.stroke = 'transparent'
    self.fill = template.caption['color']
    self.stroke = template.caption['stroke']
    self.stroke_width = 1
    self.font_weight = Magick::BoldWeight
    # self.rotation = 270
    self.kerning = 1
    self.interline_spacing = 7
    self.align = CenterAlign
  end
end

output = "#{File.dirname(template.image['path'])}/mojo_#{File.basename(template.image['path'])}"
puts "Writing to #{output}"
imgl.write(output)

exit