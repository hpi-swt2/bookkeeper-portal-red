class GroupNameComponent < ViewComponent::Base
  def initialize(group:)
    super
    @group = group
  end
end
