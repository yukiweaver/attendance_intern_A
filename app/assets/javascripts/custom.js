$(document).on('turbolinks:load', function() {

  $(function(){
    year = moment().format('YYYY');
		month = moment().format('MM');
		
    $("#year li").click(function(){
      year = $(this).attr("id");
      $("#year input").val(year);
      // alert(year);
      
      $.ajax({
        type:'GET', // リクエストのタイプはGET
        url: '/attendance/approval_histories', // URLを指定
        data: {month: month, year: year}, // コントローラへフォームの値を送信
        dataType: 'json' // データの型はjson
      })
      
      .done(function(data){
        // 通信に成功した場合の処理
        $('tbody').find('tr').remove();
        $('tbody').find('td').remove();
        
        $(data).each(function(i, approval_history){
          approval_history.first_beginning_time == null ?
          first_beginning_time = '' : first_beginning_time = moment(approval_history.first_beginning_time).format('HH:mm');
          approval_history.first_leaving_time == null ?
          first_leaving_time = '' : first_leaving_time = moment(approval_history.first_leaving_time).format('HH:mm');
          approval_history.beginning_time == null ?
          beginning_time = '' : beginning_time = moment(approval_history.beginning_time).format('HH:mm');
          approval_history.leaving_time == null ?
          leaving_time = '' : leaving_time = moment(approval_history.leaving_time).format('HH:mm');
          
          $('tbody').append(
            $("<tr>")
            .append("<td>" + approval_history.attendance_day + "</td>")
            .append("<td>" + first_beginning_time + "</td>")
            .append("<td>" + first_leaving_time + "</td>")
            .append("<td>" + beginning_time + "</td>")
            .append("<td>" + leaving_time + "</td>")
            .append("<td>" + approval_history.authorizer_user + "</td>")
            .append("<td>" + moment(approval_history.attendance_approval_date).format("YYYY-MM-DD") + "</td>")
            .append("</tr>")
          )
        })
      })
    });
    
    $("#month li").click(function(){
      month = $(this).attr("id");
      $("#month input").val(month);
      // alert(year);
      
      $.ajax({
        type:'GET', // リクエストのタイプはGET
        url: '/attendance/approval_histories', // URLを指定
        data: {month: month, year: year}, // コントローラへフォームの値を送信
        dataType: 'json' // データの型はjson
      })
      
      .done(function(data){
        // 通信に成功した場合の処理
        $('tbody').find('tr').remove();
        $('tbody').find('td').remove();
        
        $(data).each(function(i, approval_history){
          approval_history.first_beginning_time == null ?
          first_beginning_time = '' : first_beginning_time = moment(approval_history.first_beginning_time).format('HH:mm');
          approval_history.first_leaving_time == null ?
          first_leaving_time = '' : first_leaving_time = moment(approval_history.first_leaving_time).format('HH:mm');
          approval_history.beginning_time == null ?
          beginning_time = '' : beginning_time = moment(approval_history.beginning_time).format('HH:mm');
          approval_history.leaving_time == null ?
          leaving_time = '' : leaving_time = moment(approval_history.leaving_time).format('HH:mm');
          
          $('tbody').append(
            $("<tr>")
            .append("<td>" + approval_history.attendance_day + "</td>")
            .append("<td>" + first_beginning_time + "</td>")
            .append("<td>" + first_leaving_time + "</td>")
            .append("<td>" + beginning_time + "</td>")
            .append("<td>" + leaving_time + "</td>")
            .append("<td>" + approval_history.authorizer_user + "</td>")
            .append("<td>" + moment(approval_history.attendance_approval_date).format("YYYY-MM-DD") + "</td>")
            .append("</tr>")
          )
        })
      })
    });
    
    $("#reset").click(function(){
      year = moment().format('YYYY')
		$("#year input").val(year);
		
		month = moment().format('MM')
		$("#month input").val(month);
      
      $.ajax({
        type:'GET', // リクエストのタイプはGET
        url: '/attendance/approval_histories', // URLを指定
        data: {month: month, year: year}, // コントローラへフォームの値を送信
        dataType: 'json' // データの型はjson
      })
      
      .done(function(data){
        // 通信に成功した場合の処理
        $('tbody').find('tr').remove();
        $('tbody').find('td').remove();
        
        $(data).each(function(i, approval_history){
          approval_history.first_beginning_time == null ?
          first_beginning_time = '' : first_beginning_time = moment(approval_history.first_beginning_time).format('HH:mm');
          approval_history.first_leaving_time == null ?
          first_leaving_time = '' : first_leaving_time = moment(approval_history.first_leaving_time).format('HH:mm');
          approval_history.beginning_time == null ?
          beginning_time = '' : beginning_time = moment(approval_history.beginning_time).format('HH:mm');
          approval_history.leaving_time == null ?
          leaving_time = '' : leaving_time = moment(approval_history.leaving_time).format('HH:mm');
          
          $('tbody').append(
            $("<tr>")
            .append("<td>" + approval_history.attendance_day + "</td>")
            .append("<td>" + first_beginning_time + "</td>")
            .append("<td>" + first_leaving_time + "</td>")
            .append("<td>" + beginning_time + "</td>")
            .append("<td>" + leaving_time + "</td>")
            .append("<td>" + approval_history.authorizer_user + "</td>")
            .append("<td>" + moment(approval_history.attendance_approval_date).format("YYYY-MM-DD") + "</td>")
            .append("</tr>")
          )
        })
      })
    });
  });
});