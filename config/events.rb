WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
    subscribe :client_connected, :to => CurrentGameController, :with_method => :hello
    subscribe :client_disconnected, :to => CurrentGameController, :with_method => :goodbye
    subscribe :add_player, :to => CurrentGameController, :with_method => :add_player
    subscribe :increment_score, :to => CurrentGameController, :with_method => :increment_score
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
end
