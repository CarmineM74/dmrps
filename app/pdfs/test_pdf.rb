class TestPdf < Prawn::Document
  def initialize
    super
    text "This is a test"
    define_grid(columns:12,rows:24,gutter:5)
    grid.show_all
  end
end
