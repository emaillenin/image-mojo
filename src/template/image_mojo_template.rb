require 'psych'
class ImageMojoTemplate

  attr_accessor :all_templates, :image, :hashtag, :image_copyright
  def initialize(config_file)
    puts "Using template file #{config_file}"
    @all_templates = Psych.load(File.read(config_file))
    @image = @all_templates['image']
    @hashtag = @all_templates['hashtag']
    @image_copyright = @all_templates['image_copyright']
  end
end