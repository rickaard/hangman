# Hangman

To create a Postgresql database with Docker:

 ```
  docker run --name hangman-postgres -p 5432:5432 -e POSTGRES_PASSWORD=password -d postgres
  ```
  
* Update /config/dev.exs with your correct information 

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


