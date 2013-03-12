NikoCal.ProjectIndex = function() {
    return {
        data : {},
        currentYear : undefined,
        currentMonth : undefined,

        init : function() {
            $("#ApplyButton").bind("click", function() {
                var checkedRole = $("input[name=role]:checked", "#sidebar");
                if (checkedRole.size() == 0) {
                    app.data = {};
                } else {
                    roleIds = [];
                    checkedRole.each(function() {
                        roleIds.push($(this).val());
                    });
                    app.data.role = roleIds.join(',');
                }
                app.renderHistory(app.currentYear, app.currentMonth);
            });
            app.renderHistory();
        },

        renderHistory : function(year, month) {
            var url = window.location.pathname + "/history";
            if (year !== undefined && month !== undefined) {
                url += "/" + year + "/" + month;
                app.currentYear = year;
                app.currentMonth = month
            }

            $.ajax({
                url : url,
                type : "get",
                cache : false,
                data : app.data,
                success : function(data) {
                    var calendar = $(data);
                    $("a.nikoniko_history_pager", calendar).bind("click", app.moveHistory);
                    $("#NikonikoCalendar").html(calendar);
                    app.table2Fixed();
                }
            });
        },

        moveHistory : function(e) {
            var yearMonth = $(this).attr("href").match(/\/([0-9]{4})\/([0-9]{1,2})$/);
            app.renderHistory(yearMonth[1], yearMonth[2]);
            return false;
        },

        table2Fixed : function() {
            var fixedWidth = $("#content").width() - 20;
            var fixedHeight = $("#NikonikoCalendar .cal").outerHeight();

            $("#NikonikoCalendar .cal").fixedTable({
                width : fixedWidth,
                height : fixedHeight,
                fixedColumns : 1,
                classHeader : "fixedHead",
                classFooter : "fixedFoot",
                classColumn : "fixedColumn",
                fixedColumnWidth : 150,
                outerId : "NikonikoCalendar"
            });
        }
    };
}();
var app = NikoCal.ProjectIndex;
$(document).ready(app.init);
