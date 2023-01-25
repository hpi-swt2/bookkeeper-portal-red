class ItemBorrowButton < ViewComponent::Base
    def initialize(text:, action:, bootstrap_classes:)
      super()
      @text = text
      @action = action
      @bootstrap_classes = bootstrap_classes
    end
  end
  