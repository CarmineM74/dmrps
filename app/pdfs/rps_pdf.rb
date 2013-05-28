class RpsPdf < Prawn::Document
  def initialize(intervention)
    super()
    @intervention = intervention
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
    image "./app/assets/images/logo_dm.png", position: :left, width: 100, height: 50
  end

  def header
    location = @intervention.locations.first
    logo
    move_down 10
    grid([2,0],[3,11]).bounding_box do
      draw_bounded_rectangle(5)
      text "<b>Rapportini/Richiesta di Assistenza Tecnica\nda inviare tramite fax al nr.: 08119722772 o tramite email: ordini@dmcomputers.it</b>\nad uso esclusivo dei clienti D.M. Computers titolari di contratto di Assistenza o Manutenzione", align: :center, valign: :center, inline_format: true
    end
    grid([4,0],[5,5]).bounding_box do
      draw_bounded_rectangle(5)
      font_size 10
      text_box "<b>Societa'/Cliente richiedente</b>:\n#{@intervention.client.ragione_sociale}\n\nTel. #{location.telefono} Fax #{location.fax}", at: [10,bounds.top-10],inline_format: true
    end
    grid([4,6],[5,11]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "<b>Spett.le</b>\n<font size='7'>#{@intervention.client.ragione_sociale}\n#{location.indirizzo}\n#{location.cap} - #{location.citta} (#{location.provincia})<font>", at: [10,bounds.top-10], inline_format: true
    end
    grid([6,0],[6,5]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "<b>Data effettiva inoltro richiesta:</b> #{@intervention.data_inoltro_richiesta.strftime('%d/%m/%Y')}", at: [10,bounds.top-8], inline_format: true
    end
    grid([7,0],[7,5]).bounding_box do
      draw_bounded_rectangle(5)
      text_box "<b>Firma del richiedente:</b> ____________________", at: [10,bounds.top-8], inline_format: true
    end
    grid([6,6],[7,11]).bounding_box do
      draw_bounded_rectangle(5)
      info_contratto = (@intervention.client.nr_contratto.nil? || @intervention.client.nr_contratto.empty?) ? "<b>SENZA CONTRATTO</b>" : "<b>CONTRATTO NR: #{@intervention.client.nr_contratto}</b>"
      text_box info_contratto, at: [10,bounds.top-8], inline_format: true
    end
    font_size 8
    grid([8,0],[10,11]).bounding_box do
      draw_bounded_rectangle(0)
    end
    grid([8,0],[8,2]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Data intervento:</b> #{@intervention.data_intervento.strftime('%d/%m/%Y')}", at: [10,bounds.top-8], inline_format: true
    end
    grid([8,3],[8,6]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Contatto:</b> #{@intervention.contatto}", at: [10,bounds.top-8], inline_format: true
    end
    grid([9,0],[9,2]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Ora inizio:</b> #{@intervention.inizio.strftime('%H:%M')}", at: [10,bounds.top-8], inline_format: true
    end
    grid([9,4],[9,6]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Ora fine:</b> #{@intervention.fine.strftime('%H:%M')}", at: [10,bounds.top-8], inline_format: true
    end
    grid([10,0],[10,6]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>E-Mail:</b> #{@intervention.email}", at: [10,bounds.top-8], inline_format: true
    end
    grid([8,7],[10,11]).bounding_box do
      draw_bounded_rectangle(0)
      font_size 8
      loc = @intervention.locations.first
      text_box "<b>Indirizzo</b>\n\n<b>Via:</b> #{loc.indirizzo}\n<b>CAP:</b> #{loc.cap}\n<b>Citta':</b> #{loc.citta}\n<b>Provincia:</b> #{loc.provincia}", at: [10,bounds.top-8], inline_format: true
    end
  end

  def body
    grid([11,0],[13,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Descrizione delle anomalie o dei guasti riscontrati</b>", at: [0,bounds.top-7], align: :center, inline_format: true
      stroke do
        horizontal_line bounds.left,bounds.right, at: bounds.top-18 
      end
      text_box "#{@intervention.descrizione_anomalie}", at: [0,bounds.top-20]
    end
    grid([14,0],[19,05]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Descrizione dell'intervento effettuato</b>", at: [0,bounds.top-7], align: :center, inline_format: true
      stroke do
        horizontal_line bounds.left,bounds.right, at: bounds.top-18 
      end
      text_box "#{@intervention.descrizione_intervento}", at: [0,bounds.top-20]
    end
    grid([14,6],[19,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Elenco Attivita'</b>", at: [0,bounds.top-7], align: :center, inline_format: true
      stroke do
        horizontal_line bounds.left,bounds.right, at: bounds.top-18 
      end
      attivita = @intervention.activities.inject([]) { |a,v| a << v.descrizione; a }.join("\n")
      text_box "#{attivita}", at: [0,bounds.top-20]
    end
    grid([20,0],[21,4]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Ore lavorate c/o il cliente:</b> #{@intervention.ore_lavorate_cliente}\n<b>Ore lavorate in laboratorio:</b> #{@intervention.ore_lavorate_laboratorio}\n<b>Ore lavorate in remoto:</b> #{@intervention.ore_lavorate_remoto}\n<b>Km supplementari:</b> 0000", at: [10,bounds.top-8], inline_format: true
    end
    grid([20,5],[22,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Note</b>\n"+@intervention.note, at: [10,bounds.top-8], inline_format: true
    end
    grid([22,0],[22,4]).bounding_box do
      draw_bounded_rectangle(0)
      lav_completo = @intervention.lavoro_completato ? "SI" : "NO"
      dir_chiamata = @intervention.diritto_di_chiamata ? "SI" : "NO"
      text_box "<b>Lavoro completato:</b> #{lav_completo} - <b>Diritto di chiamata:</b> #{dir_chiamata}", at: [10,bounds.top-8], inline_format: true
    end
  end

  def footer
    grid([23,0],[24,7]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Timbro e firma del cliente</b>", at: [10,bounds.top-8], inline_format: true
    end
    grid([23,8],[24,11]).bounding_box do
      draw_bounded_rectangle(0)
      text_box "<b>Sigla del tecnico</b>", at: [10,bounds.top-8], inline_format: true
    end
  end

end
