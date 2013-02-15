NikoCal.ProjectIndex = function() {
	return {
		init: function() {
		    var fixedWidth = $("#content").width() - 20;
		    var fixedHeight = $("#NikonikoCalendar .cal").outerHeight(); 
		    
		    $("#NikonikoCalendar .cal").fixedTable({
		        width: fixedWidth,
		        height: fixedHeight,
		        fixedColumns: 1,
		        classHeader: "fixedHead",
		        classFooter: "fixedFoot",
		        classColumn: "fixedColumn",
		        fixedColumnWidth: 150,
		        outerId: "NikonikoCalendar"
		    });
		}
	};
}();
var app = NikoCal.ProjectIndex;
$(document).ready(app.init);
