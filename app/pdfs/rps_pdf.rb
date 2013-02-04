class RpsPdf < Prawn::Document
  def initialize
    super
    define_grid(columns:12,rows:24,gutter:5)
    #grid.show_all
    header
    body
    footer
  end

  def draw_bounded_rectangle(radius = 10)
    stroke do
      rounded_rectangle [bounds.left,bounds.top],bounds.right,bounds.top,radius
    end
  end

  def logo
    grid([0,0],[1,5]).bounding_box do
      draw_bounded_rectangle(20)
    end
    grid([0,1],[1,4]).bounding_box do
      draw_text "LOGO HERE", :at => [0,25]
    end
  end

  def header
    logo
    grid([2,0],[3,11]).bounding_box do
      draw_bounded_rectangle(5)
      text "Rapportini/Richiesta di Assistenza Tecnica\nda inviare tramite fax al nr.: 08119722772 o tramite email: ordini@dmcomputers.it\nad uso esclusivo dei clienti D.M. Computers titolri di contratto di Assistena o Manutenzione", align: :center, valign: :center
    end
    grid([4,0],[5,5]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "Societa'/Cliente richiedente:\n\nTel. ____________ Fax ____________", at: [10,bounds.top-10]
    end
    grid([4,6],[5,11]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "Spett.le\nD.M. COMPUTERS VIA AVERSA, 62\n81030 - GRICIGNANO DI AVERSA (CE)\nTel 0815028568", at: [10,bounds.top-2]
    end
    grid([6,0],[6,5]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "Data effettiva inoltro richiesta: __/__/____", at: [10,bounds.top-8]
    end
    grid([7,0],[7,5]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "Firma del richiedente: ____________________", at: [10,bounds.top-8]
    end
    grid([6,6],[7,11]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "CONTRATTO NR: _________________\n\nSENZA CONTRATTO: _________________", at: [10,bounds.top-8]
    end
    font_size 8
    grid([8,0],[10,11]).bounding_box do
      draw_bounded_rectangle(0)
    end
    grid([8,0],[8,2]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Data intervento: __/__/____", at: [10,bounds.top-8]
    end
    grid([8,3],[8,6]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Contatto: _____________________________", at: [10,bounds.top-8]
    end
    grid([9,0],[9,2]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Ora inizio: HH:MM", at: [10,bounds.top-8]
    end
    grid([9,4],[9,6]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Ora fine: HH:MM", at: [10,bounds.top-8]
    end
    grid([10,0],[10,6]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "E-Mail: ________________________________________________________", at: [10,bounds.top-8]
    end
    grid([8,7],[10,11]).bounding_box do
      draw_bounded_rectangle(0)
      font_size 10
      text_box "Indirizzo\n\nVia: _____________________________\nCAP: ______\nCitta': __________________________\nProvincia: __", at: [10,bounds.top-8]
    end
  end

  def body
    grid([11,0],[14,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Descrizione delle anomalie o dei guasti riscontrati", at: [0,bounds.top-7], align: :center
      stroke do
        horizontal_line bounds.left,bounds.right, at: bounds.top-18 
      end
    end
    grid([15,0],[18,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Descrizione dell'intervento effettuato", at: [0,bounds.top-7], align: :center
      stroke do
        horizontal_line bounds.left,bounds.right, at: bounds.top-18 
      end
    end
    grid([19,0],[21,4]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Ore lavorate c/o il cliente: 000\nOre lavorate in laboratorio: 000\nOre lavorate in remoto: 000\nKm supplementari: 0000", at: [10,bounds.top-8]
    end
    grid([19,5],[22,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Note\n"+"_"*270, at: [10,bounds.top-8]
    end
    grid([22,0],[22,4]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Lavoro completato: SI - Diritto di chiamata: NO", at: [10,bounds.top-8]
    end
  end

  def footer
    grid([23,0],[24,7]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Timbro e firma del cliente", at: [10,bounds.top-8]
    end
    grid([23,8],[24,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "Sigla del tecnico", at: [10,bounds.top-8]
    end
  end

end
