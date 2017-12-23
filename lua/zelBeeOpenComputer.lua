local component = require("component")

local beeHouse = component.bee_housing
local beeBreedingData = beeHouse.getBeeBreedingData()

function constructBeeTree()
	local beeCount = 1
	local beeNames = {}
	local treeRoots = {}
	treeRoots.count = 0
	
	for k,v in ipairs(beeHouse.listAllSpecies()) do
		beeNames[v.name] = true
		beeCount = beeCount + 1;
	end
	
	local endBees = findEndTierBees()
	
	for k,v in pairs(endBees) do
		createBeeTree(k, treeRoots)
		print("The bee "..k.." needs:")
		treeRoots[treeRoots.count].rootNode = populateNode(k)
	end	
end

function findEndTierBees()
	local HighTierBees = {}

	for k, v in ipairs(beeBreedingData) do
		local foundMatch = false
		for kToMatch, vToMatch in ipairs(beeBreedingData) do
			if v.result == vToMatch.allele1 or v.result == vToMatch.allele2 then
				foundMatch = true
				
			end
		
		end
		
		if foundMatch == false then
			HighTierBees[v.result] = true
		end
		
	end
	
	for k,v in pairs(HighTierBees) do
		--print(k)
	
	end
	return HighTierBees
end

function populateNode(curBeeName)
	local currentNode = createBeeNode(curBeeName)
	local children = findBeeBreedInfo(curBeeName)
	
	if children ~= nil then
		print("Bee "..curBeeName.." needs "..children.allele1.." "..children.allele2)
		node.left = populateNode(children.allele1)
		node.right = populateNode(children.allele2)
	else
		print("Basic Bee "..curBeeName)
	end
	
	
	return currentNode
end


function findBeeBreedInfo(beeName)
	for k, v in ipairs(beeBreedingData) do
		if v.result == beeName then
			--print(beeName.." "..v.allele1.." "..v.allele2)
			return v
		end
	end
	
	return nil
end

function createBeeTree(firstBeeName, treeRoots)
	local newTree = {}
	newTree.rootNode = {}
	treeRoots.count = treeRoots.count + 1
	treeRoots[treeRoots.count] = newTree
	
	return newTree
end

function createBeeNode(beeName)
	local node = {}
	node.name = beeName
	node.left = nil
	node.right = nil
	
end


constructBeeTree()

