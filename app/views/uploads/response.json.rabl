if @errors.any?
  node(:errors) { @errors.to_json }
else
  node(:segments) { partial 'segments/_segment', :object => @segments }
end
