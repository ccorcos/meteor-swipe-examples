Meteor.publish 'lists', ->
  Lists.find {ownerId: @userId}

Meteor.publish 'tasks', (listId) ->
  Tasks.find {listId: listId, ownerId: @userId}
