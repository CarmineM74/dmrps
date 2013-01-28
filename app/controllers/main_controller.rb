class MainController < ApplicationController
  def index
  end

  def test_pdf
    respond_to do |format|
      format.pdf do
        pdf = TestPdf.new
        send_data pdf.render,filename: "test.pdf", type: "application/pdf"
      end
    end
  end

end
