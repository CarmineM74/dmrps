class RpsPdf < Prawn::Document
  def initialize
    super
    define_grid(columns:12,rows:24,gutter:5)
    grid.show_all
    header
    body
    footer
  end

  def header
  end

  def body
  end

  def footer
  end

end
