PDFKit.configure do |config|
  config.wkhtmltopdf = 'C:/wkhtmltopdf/wkhtmltopdf.exe'
  config.default_options = {
  :page_size => 'Legal',
  :print_media_type => true
}
end
