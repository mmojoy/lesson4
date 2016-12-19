<% if params.dig(:done) %>
$('#boss').prop('checked', true)
<% else %>
$('#boss').prop('checked', false)
<% end %>
$('input:checkbox').prop('checked', $('input#boss')[0].checked)
$("#tasks:not([data-type=''])").slideUp()
