object false

node(:items) do
  partial 'api/segments/_segment', :object => @segments
end

node(:current_page) { @segments.current_page }
node(:total_pages) { @segments.num_pages }
node(:per_page) { Kaminari.config.default_per_page }
node(:total_entries) { @segments.total_count }
