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

// $(function(){
//   $("#ac2").click(function(){
//     $(this).find(".accordion2").slideToggle();
//     // $(".accordion2").slideToggle();
//   });
// });
