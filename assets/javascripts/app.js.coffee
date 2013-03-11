#= require vendor/jquery-1.8.3.min.js
#= require vendor/underscore-1.4.4.js
#= require vendor/backbone-0.9.10.js
#= require hamlcoffee

#= require bootstrap.js
#= require_tree ./models
#= require_tree ./views
#= require_tree ./templates

class MyRouter extends Backbone.Router
    routes:
        "": "index"
        "auth": "auth"
    index: ->
        console.log "index in router"
        if not app.is_fb_authed
            return app.navigate('auth')

        collection = new Model.FriendList
        collection.fetch()
        view = new View.FriendList({collection: collection})
        view.render()
        app.currentView = view
        $('#app').html(view.el)
    start: ->
        console.log "starting backbone"
        Backbone.history.start()
    auth: ->
        console.log "auth index in router"
        if app.is_fb_authed
            return app.navigate("")

        auth = new Model.Auth()
        view = new View.Auth({model: auth})
        view.render()
        app.currentView = view
        $('#app').html(view.el)

class App
    router: new MyRouter()
    is_fb_authed: false
    navigate: (hash) ->
        console.log "navigating to ", hash
        @currentView?.remove()
        @currentView = null
        @router.navigate(hash, true)

$ ->
    $('body').prepend($("<div/>", {id: 'fb-root'}))
    window.fbAsyncInit = =>
        FB.init({
            appId : '413203055432918'
            channelUrl: ''
            status : false
            cookie : true
        })

        Backbone.sync = (method, model, options) =>
            if method is 'read'
                FB.api(model.endpoint, (response) -> 
                    options.success(model, response, options)
                )
            else
                console.log "not implemented method"

        window.app = new App()
        window.app.router.start()

    js = document.createElement('script')
    js.id = 'facebook-jssdk'
    js.async = true
    js.src = "//connect.facebook.net/en_US/all.js"
    document.getElementsByTagName('head')[0].appendChild(js)


