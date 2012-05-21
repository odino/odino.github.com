$(document).ready(function(){
	var frontPageImg = $('.front-title p img')
 
	frontPageImg.attr('class', 'left')
	frontPageImg.css('margin-top', '0.6em');
	frontPageImg.css('margin-right', '0.9em');

	displayImageCaption();
});

var displayImageCaption = function() {
	$('.entry-content img').each(function(index){
		if ($(this).attr('title') != null) {
			var wrapper 	= $('<div>')
			wrapper.attr('class', 'imageCaption')
			var string = $(this).attr('title').split("|")
			var title = string[0]
			var top = string[1]
			var caption 	= $('<p>');
			caption.html(title.split('%nl').join('<br />'))
			$(this).closest('p').append(wrapper)
			wrapper.append($(this)).append(caption)
			caption.css('top', top);
		}
	})
};