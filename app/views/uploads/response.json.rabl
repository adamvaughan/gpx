if @error
  node(:error) { @error.to_json }
else
  node(:rides) { partial 'api/rides/_ride', :object => @rides }
end
