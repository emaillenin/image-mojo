require 'RMagick'
include Magick

Dir[File.dirname(__FILE__) + '/src/**/*.rb'].each { |file| require file }

template = ImageMojoTemplate.new(ARGV[0])

imgl = Magick::ImageList.new

src = Magick::Image.read(template.image['path']).first

puts "#{src.columns}x#{src.rows}"

start_x = template.copyright['x_offset']
start_y = (src.rows/2) - template.copyright['height']
end_x = start_x + template.copyright['width']
end_y = (src.rows/2) + template.copyright['height']

imgl.from_blob(File.open(template.image['path']).read)

copyright_box = Magick::Draw.new
copyright_box.fill_opacity(template.copyright['opacity'])
copyright_box.rectangle(start_x, start_y, end_x, end_y)
copyright_box.font(template.copyright['font'])
copyright_box.draw(imgl)

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

unless template.hashtag.nil?
  watermark_text = Magick::Draw.new
  watermark_text.annotate(imgl, 0, 0, 10, 25, "##{template.hashtag['text']}") do
    self.gravity = Magick::EastGravity
    self.pointsize = 18
    self.font_family = template.hashtag['font']
    self.font_weight = Magick::BoldWeight
    self.stroke = 'transparent'
    self.fill = template.hashtag['color']
    self.kerning = 1
    self.align = LeftAlign
  end
end

output = "#{File.dirname(template.image['path'])}/mojo_#{File.basename(template.image['path'])}"

template.all_templates.keys.select { |key| key.to_s.start_with?('caption') }.each do |caption|
  a = ImageAnnotate.new(src, imgl, template.all_templates[caption])
  a.apply_template
  puts "Writing to #{output}"
  imgl.write(output)
end


exit