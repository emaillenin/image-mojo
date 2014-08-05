require 'psych'
class ImageMojoTemplate

  attr_accessor :all_templates, :copyright, :caption, :image, :hashtag
  def initialize(config_file)
    puts "Using template file #{config_file}"
    @all_templates = Psych.load(File.read(config_file))
    @copyright = @all_templates['copyright']
    @caption = @all_templates['caption']
    @image = @all_templates['image']
    @hashtag = @all_templates['hashtag']
  end
end