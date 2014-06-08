require 'psych'
class ImageMojoTemplate

  attr_accessor :copyright, :caption, :image
  def initialize(config_file)
    template = Psych.load(File.read(config_file))
    @copyright = template['copyright']
    @caption = template['caption']
    @image = template['image']
  end
end