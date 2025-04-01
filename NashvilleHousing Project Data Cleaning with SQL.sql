/*

cleaning Data in SQL Queries

*/

Select *
from PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------------------------------------------------------------------


-- Standardize Date Format


Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)




-----------------------------------------------------------------------------------------------------------------------


-- Populate Property Address data



Select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 

Select *
from PortfolioProject.dbo.NashvilleHousing



---------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)



Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


SELECT --# to get rid of the comma 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 ,  LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing
SET PropertySplitCity  = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1 ,  LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing




--# Breaking out address into three coloumn
Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
Parsename(Replace(OwnerAddress,',', '.') ,3)
,Parsename(Replace(OwnerAddress,',', '.') ,2)
,Parsename(Replace(OwnerAddress,',', '.') ,1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress,',', '.') ,3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitCity  = Parsename(Replace(OwnerAddress,',', '.') ,2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitState  = Parsename(Replace(OwnerAddress,',', '.') ,1)


Select *
From PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field  way as standardizing the data

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing




-----------------------------------------------------------------------------------------------------

--Finding  Duplicates Rows

WITH RowNumCTE AS(
Select *,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  Saledate,
			  LegalReference
			  ORDER BY
			     UniqueID
				 ) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


---------------------------------------------------------------------------------------


-- Deleting duplicate rows

WITH RowNumCTE AS(
Select *,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  Saledate,
			  LegalReference
			  ORDER BY
			     UniqueID
				 ) row_num

From PortfolioProject.dbo.NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



----------------------------------------------------------------------------------------------------------------
-- Removing unwanted Rows 


Select *
From PortfolioProject.dbo.NashvilleHousing

Alter TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate