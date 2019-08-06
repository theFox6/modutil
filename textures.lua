local textures = {}

function textures.inventorycube(face_1, face_2, face_3)
	return "[inventorycube{" .. string.gsub(face_1, "%^", "&")
	        .. "{" .. string.gsub(face_2, "%^", "&")
	        .. "{" .. string.gsub(face_3, "%^", "&")
end

function textures.get_node_inventory_image(nodename)
        local n = minetest.registered_nodes[nodename]
        if not n then
            return
        end
	local img = n.inventory_image
        if string.len(img) ~= 0 then
            return img
        end
        local tiles = {}
        for l, tile in pairs(n.tiles or {}) do
            tiles[l] = (type(tile) == "string" and tile) or tile.name
        end
        local chosen_tiles = { tiles[1], tiles[3], tiles[5] }
        if #chosen_tiles == 0 then
            return false
        end
        if not chosen_tiles[2] then
            chosen_tiles[2] = chosen_tiles[1]
        end
        if not chosen_tiles[3] then
            chosen_tiles[3] = chosen_tiles[2]
        end
        return textures.inventorycube(chosen_tiles[1], chosen_tiles[2], chosen_tiles[3])
end

return textures
