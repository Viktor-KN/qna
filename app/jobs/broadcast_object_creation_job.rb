class BroadcastObjectCreationJob < ApplicationJob
  queue_as :default

  def perform(stream, message)
    ActionCable.server.broadcast(stream, message)
  end
end
