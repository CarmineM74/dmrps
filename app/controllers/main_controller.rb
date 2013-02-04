class MainController < ApplicationController
  def index
  end

  def test_pdf
    respond_to do |format|
      format.pdf do
        pdf = RpsPdf.new
        send_data pdf.render,filename: "rps.pdf", type: "application/pdf"
      end
    end
  end

end
