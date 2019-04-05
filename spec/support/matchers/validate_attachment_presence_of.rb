RSpec::Matchers.define :validate_attachment_presence_of do |attr_name|
  match do |record|
    record.invalid? && record.errors[attr_name].include?('must be attached')
  end
end
