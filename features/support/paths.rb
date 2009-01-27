def path_to(page_name)
  case page_name
  
  when /the homepage/i
    root_path
  when /^the .*/i
    page_name.match(/the (.*)/)[1]
  # Add more page name => path mappings here
  else
    page_name
  end
end