class ItemBorrowButtons < ViewComponent::Base
  def initialize(item:, src_is_qrcode:, current_user:)
    super
    @item = item
    @src_is_qrcode = src_is_qrcode
    @current_user = current_user
  end

  def before_render
    @item_reserve_path = item_reserve_path(@item)
    @item_borrow_path = item_borrow_path(@item)
    @item_give_back_path = item_give_back_path(@item)
  end

  def render?
    (@item.reservable_by?(@current_user) && !@src_is_qrcode) ||
      (@item.borrowable_by?(@current_user) && @src_is_qrcode) ||
      @current_user.can_return_as_owner?(@item) ||
      (@item.borrowed_by?(@current_user) && @src_is_qrcode)
  end

end