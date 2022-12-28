# frozen_string_literal: true

class InfoboxComponent < ViewComponent::Base
  def initialize(heading:, body:, bootstrap_classes:)
    super()
    @heading = heading
    @body = body
    @bootstrap_classes = bootstrap_classes
  end
end
