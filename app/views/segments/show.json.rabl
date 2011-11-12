object @segment

if @segment.errors.any?
  node(:errors) { |segment| segment.errors.to_json }
else
  extends 'segments/_segment'
end
