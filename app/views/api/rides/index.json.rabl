object false

node(:items) do
  partial 'api/rides/_ride', :object => @rides
end

if @rides.respond_to? :current_page
  node(:current_page) { @rides.current_page }
  node(:total_pages) { @rides.num_pages }
  node(:per_page) { Kaminari.config.default_per_page }
  node(:total_entries) { @rides.total_count }
end
