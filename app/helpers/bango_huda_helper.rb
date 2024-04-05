require "rqrcode"
module BangoHudaHelper
  def qrcode
    # url入力
    qrcode = RQRCode::QRCode.new("#{current_user.uuid}")
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
