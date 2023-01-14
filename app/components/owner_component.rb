class OwnerComponent < ViewComponent::Base
  def initialize(item:)
    super
    @item = item
  end
end
