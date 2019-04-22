if Rails::VERSION::MAJOR > 5
  # https://github.com/rails/rails/issues/18519
  raise RuntimeError, 'Rails 6 and later have build-in support for serialization Time and Date objects in ActiveJobs.' \
                      'Remove this code.'
end

class ActiveSupport::TimeWithZone
  include GlobalID::Identification

  def id
    (Time.zone.now.to_f * 1000).round
  end

  def self.find(milliseconds_since_epoch)
    Time.zone.at(milliseconds_since_epoch.to_f / 1000)
  end
end

class Time
  include GlobalID::Identification

  def id
    (Time.zone.now.to_f * 1000).round
  end

  def self.find(milliseconds_since_epoch)
    Time.zone.at(milliseconds_since_epoch.to_f / 1000)
  end
end


class Date
  include GlobalID::Identification

  alias_method :id, :to_s
  def self.find(date_string)
    Date.parse(date_string)
  end
end
