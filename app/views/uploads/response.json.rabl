if @error
  node(:error) { @error.to_json }
else
  node(:segments) { partial 'segments/_segment', :object => @segments }
end
