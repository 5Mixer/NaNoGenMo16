var words = $("#TopLevelStory").text().split(" ");
var text = words.join("</span> <span>");
$("#TopLevelStory").html("<span>" + text + "</span>");
function seperateWords (){
	$("body").find("span").click(function () {
		var a = $(this).text();
		$(this).replaceWith("<expansion>"+"<span>"+a.toUpperCase()+"</span>  </expansion>");
		seperateWords();
	});


}
seperateWords();
