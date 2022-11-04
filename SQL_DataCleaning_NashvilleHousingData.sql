/*

Cleaning Data in SQL Queries

*/

SELECT *
from SQLPROJECT.dbo.NashvilleHousing



-- Changing the date format


SELECT SaleDateConverted, CONVERT (Date,SaleDate)
from SQLPROJECT.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate=CONVERT (Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted=CONVERT (Date,SaleDate)



-- Populate Property Address data


SELECT *
from SQLPROJECT.dbo.NashvilleHousing
-- where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from SQLPROJECT.dbo.NashvilleHousing a
JOIN SQLPROJECT.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from SQLPROJECT.dbo.NashvilleHousing a
JOIN SQLPROJECT.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null



-- Breaking Out Address into Individual Columns(Address,City,State)



SELECT PropertyAddress
from SQLPROJECT.dbo.NashvilleHousing
---- where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

from SQLPROJECT.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity  Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT * 
from SQLPROJECT.dbo.NashvilleHousing




-- Spliting PropertyAddress



SELECT OwnerAddress
from SQLPROJECT.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3) 
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from SQLPROJECT.dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'), 3) 

ALTER TABLE NashvilleHousing
Add OwnerSplitCity  Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState  Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


SELECT *
from SQLPROJECT.dbo.NashvilleHousing



-- Change Y and N to Yes and No in "Sold as Vacant" field



SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from SQLPROJECT.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant
, CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END
from SQLPROJECT.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE 
	When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END


from SQLPROJECT.dbo.NashvilleHousing



-- Remove Duplicates



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From SQLPROJECT.dbo.NashvilleHousing
-- ORDER BY ParcelID
)
Select * 
from RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From SQLPROJECT.dbo.NashvilleHousing



-- Delete Unused columns


Select *
From SQLPROJECT.dbo.NashvilleHousing

ALTER TABLE SQLPROJECT.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE SQLPROJECT.dbo.NashvilleHousing
DROP COLUMN SaleDate