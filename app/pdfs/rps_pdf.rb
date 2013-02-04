class RpsPdf < Prawn::Document
  def initialize
    super
    define_grid(columns:12,rows:24,gutter:5)
    #grid.show_all
    header
    body
    footer
  end

  def logo
    grid([0,0],[1,5]).bounding_box do
      stroke do
        rounded_rectangle [bounds.left,bounds.top],bounds.right,bounds.top,20
      end
    end
    grid([0,1],[1,4]).bounding_box do
      draw_text "LOGO HERE", :at => [0,25]
    end
  end

  def header
    logo
    grid([2,0],[3,11]).bounding_box do
      stroke do
        rounded_rectangle [bounds.left,bounds.top],bounds.right,bounds.top,10
      end
      text "Rapportini/Richiesta di Assistenza Tecnica\nda inviare tramite fax al nr.: 08119722772 o tramite email: ordini@dmcomputers.it\nad uso esclusivo dei clienti D.M. Computers titolri di contratto di Assistena o Manutenzione", align: :center, valign: :center
    end
    grid([4,0],[5,5]).bounding_box do
      stroke do
        rounded_rectangle [bounds.left,bounds.top],bounds.right,bounds.top,10
      end
      text_box "Societa'/Cliente richiedente:\n\nTel. ____________ Fax ____________", at: [10,bounds.top-10]
    end
    grid([4,6],[5,11]).bounding_box do
      stroke do
        rounded_rectangle [bounds.left,bounds.top],bounds.right,bounds.top,10
      end
      text_box "Spett.le\nD.M. COMPUTERS VIA AVERSA, 62\n81030 - GRICIGNANO DI AVERSA (CE)\nTel 0815028568", at: [10,bounds.top-2]
    end
  end

  def body
  end

  def footer

  end

end
