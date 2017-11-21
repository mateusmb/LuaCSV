module(..., package.seeall)

function string:split(separator, max, regexp)
  if separator == '' then
    separator = ','
  end

  if max and max < 1 then
    max = nil
  end

  local record = {}

  if self:len() > 0 then
    local plain = not regexp
    max = max or -1

    local field, start = 1, 1
    local first, last = self:find(separator, start, plain)
    while first and max ~= 0 do
      record[field] = self:sub(start,first-1)
      field = field+1
      start = last+1
      first, last = self:find(separator, start, plain)
      max = max-1
    end
    record[field] = self:sub(start)
  end

  return record
end


function read(path, sep, tonum, null)
  tonum = tonum or true
  sep = sep or ','
  null = null or ''
  local csv_file = {}
  local file = assert(io.open(path, "r"))
  for line in file:lines() do
    fields = line:split(sep)
    if tonum then
      for i=1,#fields do
        local field = fields[i]
        if field == '' then
          field = null
        end
        fields[i] = tonumber(field) or field
      end
    end
    table.insert(csv_file, fields)
  end
  file:close()
  return csv_file
end


function write(path, data, sep)
  sep = sep or ','
  local file = assert(io.open(path, "w"))
  for i=1,#data do
    for j=1,#data[i] do
      if j>1 then file:write(sep) end
      file:write(data[i][j])
    end
    file:write('\n')
  end
  file:close()
end
