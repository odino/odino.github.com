module Slideshare

	class SlideshareTag < Liquid::Tag
		def initialize(tag_name, ref, tokens)
			super
			@slides = ref.split(" ")
                        @tokens = tokens
		end

		def render(context)
			unless @slides.nil?
				'<div class="slideshare" id="__ss_' + @slides[0] + '"><iframe src="http://www.slideshare.net/slideshow/embed_code/' + @slides[0] +  ' " width="' + @slides[1]+ '" height="' + @slides[2] + '" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe></div>'
			end
		end
	end
end

Liquid::Template.register_tag('slideshare', Slideshare::SlideshareTag)
