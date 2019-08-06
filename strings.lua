local strings = {}

function strings.starts_with(str, start)
	return str:sub(1, start:len()) == start
end

function strings.ends_with(str, suffix)
	return str:sub(str:len()-suffix:len()+1) == suffix
end

function strings.overwrite_string()
	string.starts_with = strings.starts_with
	string.ends_with = strings.ends_with
end

return strings
