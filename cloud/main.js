// iOS hug
Parse.Cloud.define("iosPushHugSent", function(request, response) {

  // request has 2 parameters: params passed by the client and the authorized user                                                                                                                               
  var params = request.params;
  var user = request.user;

  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios'); // targeting iOS devices only 
  pushQuery.containedIn('userId', params.userIds); //receiver Ids                                                                                                                                      

  Parse.Push.send({
    where: pushQuery, // Set our Installation query                                                                                                                                                              
    data: {
      alert: params.alert,
      badge: params.badge,
      msgId: params.msgId
    }
  }, { success: function() {
      console.log("#### PUSH OK");
  }, error: function(error) {
      console.log("#### PUSH ERROR" + error.message);
  }, useMasterKey: true});

  response.success('success');
});

// iOS hug friend
Parse.Cloud.define("iosPushHugFriendNotification", function(request, response) {

  // request has 2 parameters: params passed by the client and the authorized user                                                                                                                               
  var params = request.params;
  var user = request.user;

  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios'); // targeting iOS devices only  
  pushQuery.equalTo('userId', params.userId); //receiver Id                                                                                                                                       

  Parse.Push.send({
    where: pushQuery, // Set our Installation query                                                                                                                                                              
    data: {
      alert: params.alert,
      badge: params.badge,
      msgId: params.msgId
    }
  }, { success: function() {
      console.log("#### PUSH OK");
  }, error: function(error) {
      console.log("#### PUSH ERROR" + error.message);
  }, useMasterKey: true});

  response.success('success');
});

Parse.Cloud.afterSave("Hugs", function(request) {
  var id = request.object.get("senderId");

  //When getUser(id) is called a promise is returned. Notice the .then this means that once the promise is fulfilled it will continue. See getUser() function below.
  getUser(id).then
  (   
      //When the promise is fulfilled function(user) fires, and now we have our USER!
      function(user)
      {
           var hugsQuery = new Parse.Query("Hugs");
           hugsQuery.equalTo('senderId', user.get("objectId")); 

           hugsQuery.find({
              success: function(results) {
                  user.set("HUGS", results.length);
                  //reset to zero moods
                  user.set("CURIOUS", 0);
                  user.set("EXCITED", 0);
                  user.set("HAPPY", 0);
                  user.set("LOVING", 0);
                  user.set("PARTY", 0);
                  user.set("SAD", 0);
                  var totalDuration = 0
                  for (var i = 0; i < results.length; ++i) {
                      totalDuration += results[i].get("DURATION");
                      var mood = results[i].get("mood");
                      var currentMoodCount = user.get(mood);
                      user.set(mood, currentMoodCount + 1);
                  }
                  user.set("DURATION", totalDuration);
                  user.save()
              },
              error: function() {
                  console.error("Hug lookup failed");
              }
           });
      }
      ,
      function(error)
      {
          console.error("Got an error " + error.code + " : " + error.message);
      }
  );
});

function getUser(userId) {
    Parse.Cloud.useMasterKey();
    var userQuery = new Parse.Query(Parse.User);
    userQuery.equalTo("objectId", userId);

    //Here you aren't directly returning a user, but you are returning a function that will sometime in the future return a user. This is considered a promise.
    return userQuery.first
    ({
        success: function(userRetrieved)
        {
            //When the success method fires and you return userRetrieved you fulfill the above promise, and the userRetrieved continues up the chain.
            return userRetrieved;
        },
        error: function(error)
        {
            return error;
        }
    });
};