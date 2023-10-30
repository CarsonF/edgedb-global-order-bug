module default {
  type Project extending Resource {
    required name: str {
      constraint exclusive;
    };

    multi link members := .<project[is Project::Member];
    single link membership := (select .members filter .user.id = global currentUserId limit 1);
  }
}

module Project {
  abstract type Resource extending default::Resource {
    required project: default::Project {
      readonly := true;
      on target delete delete source;
    };
  }

  type Member extending Resource {
    required user: default::User {
      readonly := true;
      on target delete delete source;
    };
    constraint exclusive on ((.project, .user));
  }
}
