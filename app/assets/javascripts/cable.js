// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

}).call(this);

// 勤怠A：拠点情報の追加ボタン　アコーディオン
$(function(){
  $("#ac1").click(function(){
    $(".accordion1").slideToggle();
  });
});

// 勤怠A：ユーザ一覧csvインポート
function file_selected(file_field){
    var filename = $(file_field)[0].files[0].name;
    $("#filename").val(filename);
  }

// $(function(){
//   $("#modal-open").click(function(){
//     $("body").append('<div id="modal-bg"></div>');
//     modalResize();
//     $("#modal-bg,#modal-main").fadeIn("slow");
//     $("#modal-bg,#modal-main").click(function(){
//       $("#modal-main,#modal-bg").fadeOut("slow",function(){
//         $('#modal-bg').remove();
//       });
//     });
//   });
// });
