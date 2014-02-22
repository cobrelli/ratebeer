var BREWERIES = {};

BREWERIES.show = function(){
	$("#brewerytable tr:gt(0)").remove();

	var table = $("#brewerytable");

	$.each(BREWERIES.list, function(index, brewery){
		table.append('<tr>'
			+ '<td>'+brewery['name']+'</td>'
			+ '<td>'+brewery['year']+'</td>'
			+ '<td>'+brewery['count']+'</td>'
			+'</tr>');
	});
};

BREWERIES.sort_by_name = function(){
    BREWERIES.list.sort( function(a,b){
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};



$(document).ready(function(){
	$("#name").click(function(e){
		BREWERIES.sort_by_name();
		BREWERIES.show();
		e.preventDefault();
	});
	//console.log($("#beertable").length);
	if ( $("#brewerytable").length>0 ) {
		$.getJSON('breweries.json', function(breweries){
			BREWERIES.list = breweries;
			BREWERIES.sort_by_name();
			BREWERIES.show();
		});
	};
});