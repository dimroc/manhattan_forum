// https://parse.com/docs/cloud_code_guide#functions-aftersave
Parse.Cloud.afterSave("Comment", function(request) {
  query = new Parse.Query("Post");
  query.get(request.object.get("post").id, {
    success: function(post) {
      post.increment("comments");
      post.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});
