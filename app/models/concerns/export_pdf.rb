module ExportPdf
  extend ActiveSupport::Concern

  def to_pdf
    qr_code = RQRCode::QRCode.new(Rails.application.routes.url_helpers.item_url(self, host: "localhost:3000"))

    Prawn::Document.new do
      render_qr_code(qr_code)
    end.render
  end
end
