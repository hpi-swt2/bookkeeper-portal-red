module ExportPdf
  extend ActiveSupport::Concern

  def to_pdf
    qr_code = RQRCode::QRCode.new(File.join(
                                    Rails.application.routes.url_helpers.item_url(self,
                                                                                  host: "localhost:3000"), "/?source=qrcode"
                                  ))
    Prawn::Document.new do
      render_qr_code(qr_code)
    end.render
  end
end
