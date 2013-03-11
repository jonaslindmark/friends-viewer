class View.Auth extends Backbone.View
    model: Model.Auth
    events:
        'click .auth-button': 'fbauth'
    tagName: 'div'
    render: =>
        html = JST['auth']()
        @$el.html(html)
        console.log "auth rendered"
        return @
    fbauth: ->
        FB.login((response) ->
            if response.authResponse
                app.is_fb_authed = true
                app.navigate("")
        )

class View.Friend extends Backbone.View
    model: Model.Friend
    tagName: 'li'
    applyFilter: (filter) =>
        filter = filter.toLowerCase()
        name = @model.get('name').toLowerCase()
        if name.indexOf(filter) is -1
            @$el.hide()
        else
            @$el.show()
            @render()
    render: =>
        @$el.html(JST['friend']({
            name: @model.get('name')
        }))
        @$el.append(@image())
        return @
    image: =>
        return "<img src='https://graph.facebook.com/#{@model.get('id')}/picture?width=138&height=138'/>"

class View.FriendList extends Backbone.View
    initialize: ->
        @collection.on('reset', @buildFriendViews)
        @collection.on('remove', @buildFriendVies)
        @views = {}
    events: 
        'keyup #search': 'filterFriends'
    buildFriendViews: =>
        @views = {}
        @collection.each( (friend) =>
            v = new View.Friend({model: friend})
            v.render()
            @views[v.cid] = v
        )
        @render()
    render: =>
        html = JST['friends_list']()
        @$el.html(html)
        for k, v of @views
            $('#friends').append(v.el)
        console.log "friendlist rendered"
        return @
    filterFriends: =>
        filter = $('#search').val()
        for k, view of @views
            view.applyFilter(filter)
