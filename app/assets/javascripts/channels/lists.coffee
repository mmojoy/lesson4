$(document).on 'turbolinks:load', ->
  if list = $('[data-list]')[0]
    id = list.getAttribute('data-list')
    App.lists = App.cable.subscriptions.create { channel: "ListsChannel", list: id },

    received: (data) ->
      if (data.online_users)
        @markOnline(data.online_users)
      else
        return if $("[data-user=#{ data.user }]")[0]
        eval(data.action)

    markOnline: (users) ->
      $("[data-person]").removeClass()
      users.forEach (user) ->
        $("[data-person=#{user}]").addClass('online')

  else
    if App.cable.subscriptions.subscriptions.length > 0
      App.cable.subscriptions.remove(App.cable.subscriptions.subscriptions[0])
