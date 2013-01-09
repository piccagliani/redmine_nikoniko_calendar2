NikoCal.Index = function() {
    return {
        init : function() {
            app.renderHistory();
            $("#NikonikoUpdateDialog").dialog({
                autoOpen : false,
                modal : true
            });
            $("input[type=button]", "#NikonikoUpdateForm").bind("click", app.submit);
            $("a", "#NikonikoUpdateForm").bind("click", app.switchNikoniko);
        },

        renderHistory : function(year, month) {
            var url = "/nikoniko_calendar/history";
            if (year !== undefined && month !== undefined) {
                url += "/" + year + "/" + month;
            }

            $.ajax({
                url : url,
                type : "get",
                cache : false,
                success : function(data) {
                    var calendar = $(data);
                    $("a.nikoniko_history_pager", calendar).bind("click", app.moveHistory);
                    $("a.nikoniko_history", calendar).bind("click", app.showUpdateForm);
                    $("#NikonikoCalendar").html(calendar);
                }
            });
        },

        moveHistory : function(e) {
            var yearMonth = $(this).attr("href").match(/\/([0-9]{4})\/([0-9]{1,2})$/);
            app.renderHistory(yearMonth[1], yearMonth[2]);
            return false;
        },

        showUpdateForm : function(e) {
            var date = $(this).attr("href").substring(1);
            var image = $("img", this).attr("src").replace(/\?.*$/, "");
            var comment = $(this).attr("title") === "未登録" ? "" : $(this).attr("title");
            $("img", "#NikonikoUpdateForm").each(function() {
                $(this).attr("src").indexOf(image) === 0 ? $(this).css("display", "") : $(this).css("display", "none");
            });
            $("input[name=comment]", "#NikonikoUpdateForm").val(comment);
            $("input[name=date]", "#NikonikoUpdateForm").val(date);
            $("#NikonikoUpdateDialog").dialog("option", "title", date);
            $("#NikonikoUpdateDialog").dialog("open");
            return false;
        },

        switchNikoniko : function(e) {
            var current = $("img:visible", "#NikonikoUpdateForm");
            if (current.parent().next().size() === 0) {
                $("img:eq(0)", "#NikonikoUpdateForm").css("display", "");
                $("img:gt(1)", "#NikonikoUpdateForm").css("display", "none");
            } else {
                current.css("display", "none");
                $("img", current.parent().next()).css("display", "");
            }
            return false;
        },

        submit : function() {
            var current = $("img:visible", "#NikonikoUpdateForm");
            var niko = current.attr("src").match(/nikoniko_([0-3]{1})\.png/)[1];
            $.ajax({
                url : "/nikoniko_calendar/post",
                type : "post",
                cache : false,
                data : {
                    niko : niko,
                    date : $("input[name=date]", "#NikonikoUpdateForm").val(),
                    comment : $("input[name=comment]", "#NikonikoUpdateForm").val()
                },
                success : function() {
                    $("#NikonikoUpdateDialog").dialog("close");
                    var targetDate = $("#CurrentMonth").text().split("-");
                    app.renderHistory(targetDate[0], targetDate[1]);
                }
            });
        }
    };
}();
var app = NikoCal.Index;
$(document).ready(app.init);
