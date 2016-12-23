$(document).on 'turbolinks:load', ->
  if list = $('[data-list]')[0]
    checkOnline(localStorage.online)
    id = list.getAttribute('data-list')
    if App.cable.subscriptions.subscriptions.length < 1
      App.lists = App.cable.subscriptions.create { channel: "ListsChannel", list: id },

      received: (data) ->
        if (data.online_users)
          @markOnline(data.online_users)
          @rememberOnline(data.online_users)
        else
          return if $("[data-user=#{ data.user }]")[0]
          eval(data.action)

      markOnline: (users) ->
        $("[data-person]").removeClass()
        users.forEach (user) ->
          $("[data-person=#{user}]").addClass('online')

      rememberOnline: (users) ->
        localStorage.removeItem('online');
        localStorage.setItem('online', JSON.stringify(users))


  unless $('[data-list]')[0]
    App.lists.unsubscribe() if App.lists
    localStorage.removeItem('online');

checkOnline = (users)  ->
  $("[data-person]").removeClass()
  ids = JSON.parse(localStorage.getItem('online'));
  if ids
    ids.forEach (id) ->
      $("[data-person=#{id}]").addClass('online')
