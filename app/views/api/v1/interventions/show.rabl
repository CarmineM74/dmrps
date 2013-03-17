object @intervention

attributes :id,
            :data_inoltro_richiesta, :data_intervento,
            :contatto, :appunti, :descrizione_anomalie, :descrizione_intervento,
            :diritto_di_chiamata, :email, :inizio, :fine, :note,
            :ore_lavorate_cliente, :ore_lavorate_remoto, :ore_lavorate_laboratorio,
            :lavoro_completato, :totale_ore_lavorate, :km_supplementari

node :user do |i|
    partial('api/v1/users/show', object: i.user)
end

node :client do |i|
    partial('api/v1/clients/show', object: i.locations.first.client)
end

node :location do |i|
    partial('api/v1/locations/show', object: i.locations.first)
end
