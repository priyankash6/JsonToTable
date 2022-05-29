
-- JSON TO TABLE 
-- Using OPENJSON()

USE FOODITEMS
GO 

DECLARE @JSON_TABLE VARCHAR(MAX)
SELECT @JSON_TABLE = BulkColumn
FROM OPENROWSET(BULK 'D:\Priyanka\Projects\TransformDataJsonToTable\Items.json', SINGLE_CLOB)T

SELECT ItemDetails.id as ID,ItemDetails.type as ItemType,ItemDetails.name as ItemName,BatterDetails.type as Batter,ToppingDetails.type as Topping,ItemDetails.ppu as PPU
FROM OPENJSON(@JSON_TABLE)
WITH(items NVARCHAR(MAX) as JSON)
AS ItemsData
CROSS APPLY OPENJSON(ItemsData.items)
With(item NVARCHAR(MAX) AS JSON)
as Item 
CROSS APPLY OPENJSON(Item.item)
With(
	id VARCHAR(MAX),
	type VARCHAR(MAX),
	name VARCHAR(MAX),
	ppu VARCHAR(MAX),
	batters NVARCHAR(MAX) AS JSON,
	topping NVARCHAR(MAX) AS JSON
) AS ItemDetails
CROSS APPLY OPENJSON(ItemDetails.batters)
With(
	batter NVARCHAR(MAX) AS JSON
) AS Batter
CROSS APPLY OPENJSON(Batter.batter)
With(
	id VARCHAR(MAX),
	type VARCHAR(MAX)
) AS BatterDetails
CROSS APPLY OPENJSON(ItemDetails.topping)
With(
	id VARCHAR(20),
	type VARCHAR(20)
) AS ToppingDetails