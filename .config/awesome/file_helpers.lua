local file_helpers = {}
-- http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
file_helpers.file_exists = function(file)
  local f = io.open(file, "rb")
  if f then
    f:close()
  end
  return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
file_helpers.lines_from = function(file)
  if not file_helpers.file_exists(file) then
    return {}
  end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

file_helpers.first_line_from = function(file) --> string
  return file_helpers.lines_from(file)[1]
end

file_helpers.overwrite_to = function(file, text)
  local pfile = io.open(file, "w")
  pfile:write(tostring(text))
end

return file_helpers
