require 'rails_helper'

RSpec.describe BroadcastObjectCreationJob, type: :job do
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      BroadcastObjectCreationJob.perform_later("sample_stream", "sample message")
    }.to have_enqueued_job.with("sample_stream", "sample message")
    end
end
