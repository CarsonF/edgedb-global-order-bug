module default {
  global currentUserId: uuid;
  global currentUser := (select User filter .id = global currentUserId limit 1);

  type User extending Resource {
    email: str {
      constraint exclusive;
    };
  }
}
