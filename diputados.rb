require 'nokogiri'
require 'open-uri'
require 'fileutils'

# doc = Nokogiri::HTML(open('http://www.diputados.gov.ar/diputados/listadip.html')
# habria que bajar el documento de la direccion mencionada arriba y agregar tr
# a tbody para que funcione
doc = Nokogiri::HTML(File.read('listadip.html'))
doc.css('table#tablesorter > tbody tr').each do |row|
  foto_url = row.at_css('td:first-child > img')['src'].to_s
  nombre = row.at_css('td:nth-child(2) > a').content.to_s.strip
  provincia = row.at_css('td:nth-child(3)').content.to_s
  nombre_foto = nombre+'.jpg'
  File.open(nombre_foto, 'wb') do |saved_file|
    open(foto_url, 'rb') do |read_file|
      saved_file.write(read_file.read)
    end
  end
  dest = provincia+'/'+nombre_foto
  FileUtils.mkdir_p(provincia, verbose: :true, :mode => 0755) unless File.directory?(provincia)
  FileUtils.move(nombre_foto,dest)
end
