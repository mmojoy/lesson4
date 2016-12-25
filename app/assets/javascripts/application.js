// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on('change', 'input#boss', function(){
  $('input:checkbox').prop('checked', this.checked);
  $("#tasks:not([data-type=''])").slideUp()
})

$(document).on('change', '.single input[type=checkbox]', function(){
  var url = window.location.href;
  var lastPart = url.substr(url.lastIndexOf('/') + 1);
  if (lastPart == "tasks") {
   BossState()
 }
})

function BossState() {
  var checkedCount = document.querySelectorAll('.single input:checked').length;
  checkboxes = document.querySelectorAll('.single input[type=checkbox]'),
  checkall = document.getElementById('boss');
  checkall.checked = checkedCount == checkboxes.length && checkedCount != 0;
  checkall.indeterminate = checkedCount > 0 && checkedCount < checkboxes.length;
}

$(document).on('turbolinks:load', function() {
  if (document.getElementById('boss')) {
    BossState();
  }
});
$(document).ready(function(){

  var input = $(".form input:text");

  input.keyup(function(){

    if (input.val().length > 0) {
      $(this).siblings("label").addClass("focus");
    } else {
      $(this).siblings("label").removeClass("focus");

    }
  });

  var pass = $(".form input:password");

  pass.keyup(function(){

    if (pass.val().length > 0) {
      $(this).siblings("label").addClass("focus");
    } else {
      $(this).siblings("label").removeClass("focus");

    }
  });

  $(document).mouseup(function (e) {

    var container = $(".errors div");

    if (container.has(e.target).length === 0){
      container.hide();
    }
  });

});
