module ExportPdf
  extend ActiveSupport::Concern

  def to_pdf(host)
    qr_code = RQRCode::QRCode.new(File.join(
                                    Rails.application.routes.url_helpers.item_url(self,
                                                                                  host: host),
                                    "/?src=qrcode"
                                  ))
    item_name = name
    Prawn::Document.new do
      text "Item: #{item_name}", align: :center, size: 50
      render_qr_code(qr_code, extent: 300, align: :center)
    end.render
  end
end
