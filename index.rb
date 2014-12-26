require 'RMagick'
include Magick

Dir[File.dirname(__FILE__) + '/src/**/*.rb'].each { |file| require file }

template = ImageMojoTemplate.new(ARGV[0])

base_image_path = template.image['path']
src = Magick::Image.read(base_image_path).first

puts "#{src.columns}x#{src.rows}"

image_list = Magick::ImageList.new
image_list.from_blob(File.open(base_image_path).read)
image_list.alpha(Magick::ActivateAlphaChannel)

output = "#{File.dirname(base_image_path)}/mojo_#{File.basename(base_image_path)}"

logo_overlay = ImageList.new("./assets/images/#{template.image_copyright['file']}")
image_list.gravity= Magick.const_get(template.image_copyright['location'])
image_list.geometry='0x0+10+10'
rails_on_ruby = image_list.composite_layers(logo_overlay, Magick::OverCompositeOp)
rails_on_ruby.format = 'png'
rails_on_ruby.write(output)

image_list.clear
image_list.from_blob(File.open(output).read)

image_list.write(output)

unless template.hashtag.nil?
  watermark_text = Magick::Draw.new
  watermark_text.annotate(image_list, 0, 0, 10, 25, "##{template.hashtag['text']}") do
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


template.all_templates.keys.select { |key| key.to_s.start_with?('caption') }.each do |caption|
  a = ImageAnnotate.new(src, image_list, template.all_templates[caption])
  a.apply_template
  puts "Writing to #{output}"
  image_list.write(output)
end


exit 0