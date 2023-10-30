module default {
  type Engagement extending Project::Resource {
    # I want ceremony to be automatically created when engagement is created.
    # Using computed & trigger to do this, because properties with default expressions
    # cannot refer to links of inserted object.
    # Aka a default expression cannot pass the project for the engagement through to the ceremony.
    trigger connectCeremony after insert for each do (
      insert Engagement::Ceremony {
        engagement := __new__,
        project := __new__.project,
      }
    );
  }
}

module Engagement {
  abstract type Resource extending Project::Resource {
    required engagement: default::Engagement {
      readonly := true;
      on target delete delete source;
    };
  }
  type Ceremony extending Resource {
    constraint exclusive on (.engagement);
  }
}
