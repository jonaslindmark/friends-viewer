class Model.Auth extends Backbone.Model
class Model.Friend extends Backbone.Model
class Model.FriendList extends Backbone.Collection
    endpoint: '/me/friends'
    model: Model.Friend
    parse: (response) -> response.data
