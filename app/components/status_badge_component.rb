class StatusBadgeComponent < ViewComponent::Base
  def initialize(text:, bootstrap_classes:)
    super()
    @text = text
    @bootstrap_classes = bootstrap_classes
  end
end
